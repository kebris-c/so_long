/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   map_load.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/13 19:39:54 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/28 21:45:33 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

static void	put_image(t_game *game, t_img *img, int x, int y)
{
	int	offset_x;
	int	offset_y;

	offset_x = (game->win_width - game->map.width * game->tile_size);
	offset_y = (game->win_height - game->map.height * game->tile_size);
	if (!img || !img->ptr)
		return ;
	if (x < 0 || x >= game->map.width || y < 0 || y >= game->map.height)
		return ;
	mlx_put_image_to_window(game->mlx, game->win, img->ptr, \
			x * 64, y * 64);
}

void	load_map(t_game *game)
{
	int		x;
	int		y;
	char	tile;

	y = 0;
	while (game->map.tiles[y])
	{
		x = 0;
		while (game->map.tiles[y][x])
		{
			tile = game->map.tiles[y][x];
			if (tile == '0')
				put_image(game, &game->floor, x, y);
			else if (tile == '1')
				put_image(game, &game->wall, x, y);
			else if (tile == 'C')
				put_image(game, &game->collect, x, y);
			else if (tile == 'E')
				put_image(game, &game->exit, x, y);
			else if (tile == 'P')
				put_image(game, &game->player, x, y);
			x++;
		}
		y++;
	}
}
