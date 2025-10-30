/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   textures_load.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/13 19:11:49 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/24 17:31:42 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

static void	load_image(void *mlx, t_img *img, char *path)
{
	img->ptr = mlx_xpm_file_to_image(mlx, path, &img->width, &img->height);
	if (!img->ptr)
		exit(EXIT_FAILURE);
}

void	load_textures(t_game *game)
{
	char	*path;

	path = get_texture("wall.xpm");
	load_image(game->mlx, &game->wall, path);
	free(path);
	path = get_texture("collect.xpm");
	load_image(game->mlx, &game->collect, path);
	free(path);
	path = get_texture("exit.xpm");
	load_image(game->mlx, &game->exit, path);
	free(path);
	path = get_texture("player.xpm");
	load_image(game->mlx, &game->player, path);
	free(path);
	path = get_texture("floor.xpm");
	load_image(game->mlx, &game->floor, path);
	free(path);
}
