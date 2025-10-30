/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   so_long.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/08 19:39:54 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 19:16:13 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"
/*
void	ft_debugger(t_map map)
{
	int	y;

	printf("\tRaw map:\n");
	printf("\t\tmap.tiles:\n");
	y = 0;
	while (map.tiles[y])
	{
		printf("\t\t\t%s\n", map.tiles[y]);
		y++;
	}
	printf("\t\tmap.height= %d\n", map.height);
	printf("\t\tmap.width= %d\n", map.width);
	printf("\t\tmap.total_collects = %d\n\n", map.total_collects);
}*/

static int	extract_map_rows(t_map *map, const char *ber)
{
	int		fd;
	size_t	rows;
	char	*line;

	fd = open(ber, O_RDONLY);
	if (fd < 0)
		return (perror("open"), EXIT_FAILURE);
	rows = 0;
	line = get_next_line(fd);
	while (line)
	{
		rows++;
		free(line);
		line = get_next_line(fd);
	}
	close(fd);
	map->height = rows;
	if (map->height == 0)
		return (EXIT_FAILURE);
	return (EXIT_SUCCESS);
}

static int	extract_map_tiles(t_map *map, const char *ber)
{
	int		fd;
	int		i;
	char	*line;
	size_t	len;

	map->tiles = (char **)malloc(sizeof(*map->tiles) * (map->height + 1));
	if (!map->tiles)
		return (perror("malloc"), EXIT_FAILURE);
	fd = open(ber, O_RDONLY);
	if (fd < -1)
		return (perror("open"), EXIT_FAILURE);
	i = 0;
	line = get_next_line(fd);
	while (line)
	{
		len = ft_strlen(line);
		if (len > 0 && line[len - 1] == '\n')
			line[len - 1] = '\0';
		map->tiles[i++] = ft_strdup(line);
		free(line);
		line = get_next_line(fd);
	}
	map->tiles[i] = NULL;
	return (close(fd), EXIT_SUCCESS);
}

static int	validate_rectangular_map(t_map *map)
{
	int		i;
	size_t	first_width;
	size_t	current_width;

	if (!map->tiles || !map->tiles[0])
		return (EXIT_FAILURE);
	first_width = ft_strlen(map->tiles[0]);
	i = 1;
	while (map->tiles[i])
	{
		current_width = ft_strlen(map->tiles[i]);
		if (current_width != first_width)
			return (EXIT_FAILURE);
		i++;
	}
	if (first_width == 0)
		return (EXIT_FAILURE);
	map->width = first_width;
	return (EXIT_SUCCESS);
}

static int	extract_map_cols(t_map *map, const char *ber)
{
	ft_memset(map, 0, sizeof(*map));
	if (extract_map_rows(map, ber) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	if (extract_map_tiles(map, ber) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	if (validate_rectangular_map(map) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	return (EXIT_SUCCESS);
}

int	main(int argc, char **argv)
{
	size_t	av_len;
	t_map	map;
	t_game	game;

	if (argc != 2)
		return (exit_msg("Usage: ./so_long map.ber"));
	av_len = ft_strlen(argv[1]);
	if (av_len < 5 || ft_strncmp(&argv[1][av_len - 4], ".ber", 4) != 0)
		return (exit_msg("Invalid file extension"));
	ft_bzero(&game, sizeof(t_game));
	if (extract_map_cols(&map, (const char *)argv[1]) == EXIT_FAILURE)
		return (ft_erase_all(&game), exit_msg("Invalid map size"));
	game.title = "so_long";
	game.map = ft_mapcpy(map);
	if (map_checker(&game.map, map) == EXIT_FAILURE)
		return (ft_erase_all(&game), EXIT_FAILURE);
	game.tile_size = 64;
	game.win_width = game.map.width * game.tile_size;
	game.win_height = game.map.height * game.tile_size;
	if (init_game(&game) == EXIT_FAILURE)
		return (ft_erase_all(&game), exit_msg("Bad game initialize"));
	return (ft_erase_all(&game), EXIT_SUCCESS);
}
