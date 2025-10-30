/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   map_checker.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/09 10:19:57 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 16:35:49 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

static int	check_valid_chars(t_map *map, t_items *check)
{
	int			x;
	int			y;

	y = 0;
	while (map->tiles[y])
	{
		x = 0;
		while (map->tiles[y] && map->tiles[y][x])
		{
			if (ft_in_set(map->tiles[y][x], "01CEP") == EXIT_FAILURE)
				return (exit_msg("Bad chars"));
			if (map->tiles[y][x] == 'P')
				check->player++;
			if (map->tiles[y][x] == 'E')
				check->exit++;
			if (map->tiles[y][x++] == 'C')
				check->collects++;
		}
		y++;
	}
	if (check->exit != 1 || check->player != 1 || check->collects < 1)
		return (exit_msg("Bad number of items"));
	map->total_collects = check->collects;
	return (EXIT_SUCCESS);
}

static int	ft_mtxlen_checker(t_map *map)
{
	size_t	new_len;
	size_t	old_len;
	size_t	i;

	old_len = ft_strlen (map->tiles[0]);
	i = 1;
	while (map->tiles[i])
	{
		new_len = ft_strlen(map->tiles[i]);
		if (new_len != old_len)
			return (exit_msg("Invalid map size"));
		old_len = new_len;
		i++;
	}
	return (EXIT_SUCCESS);
}

static int	check_surround(t_map *map)
{
	int	x;
	int	y;

	x = 0;
	while (x < map->width)
	{
		if (map->tiles[0][x] != '1' || map->tiles[map->height - 1][x] != '1')
			return (EXIT_FAILURE);
		x++;
	}
	y = 0;
	while (y < map->height)
	{
		if (map->tiles[y][map->width - 1] != '1' || map->tiles[y][0] != '1')
			return (EXIT_FAILURE);
		y++;
	}
	return (EXIT_SUCCESS);
}

t_map	ft_mapcpy(t_map map)
{
	t_map	cpy;
	int		y;

	cpy.tiles = malloc(sizeof(char *) * (map.height + 1));
	if (!cpy.tiles)
		return ((t_map){0});
	y = 0;
	while (y < map.height)
	{
		cpy.tiles[y] = malloc(sizeof(char) * (map.width + 1));
		if (!cpy.tiles[y])
			return (ft_free_matrix(cpy.tiles), (t_map){0});
		ft_memcpy(cpy.tiles[y], map.tiles[y], map.width);
		cpy.tiles[y][map.width] = '\0';
		y++;
	}
	cpy.tiles[y] = NULL;
	cpy.width = map.width;
	cpy.height = map.height;
	cpy.total_collects = map.total_collects;
	return (cpy);
}

int	map_checker(t_map *map, t_map mapcpy)
{
	t_items	check;

	ft_bzero(&check, sizeof(t_items));
	if (check_valid_chars(map, &check) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	if (ft_mtxlen_checker(map) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	if (top_right(&mapcpy) != '1' || top_left(&mapcpy) != '1' \
		|| bottom_right(&mapcpy) != '1' || bottom_left(&mapcpy) != '1' \
			|| check_surround(map) == EXIT_FAILURE)
		return (exit_msg("Invalid map surround detected"));
	if (check_valid_route(mapcpy, &check) == EXIT_FAILURE)
		return (exit_msg("No valid route found"));
	return (EXIT_SUCCESS);
}
