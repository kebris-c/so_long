/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   game.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/09 17:22:18 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 16:30:09 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

static void	move_player(t_game *game, int dx, int dy)
{
	int		new_x;
	int		new_y;
	char	new_tile;

	new_x = game->tav.x + dx;
	new_y = game->tav.y + dy;
	new_tile = game->map.tiles[new_y][new_x];
	if (new_tile == '1')
		return ;
	if (new_tile == 'C')
		game->tav.collected++;
	if (new_tile == 'E' && game->tav.collected != game->map.total_collects)
		return ;
	game->map.tiles[game->tav.y][game->tav.x] = '0';
	game->tav.x = new_x;
	game->tav.y = new_y;
	game->moves++;
	if (game->map.tiles[game->tav.y][game->tav.x] == 'E')
	{
		game->map.tiles[new_y][new_x] = 'E';
		game->game_over = TRUE;
		return ;
	}
	game->map.tiles[new_y][new_x] = 'P';
	ft_printf("\t%d\n", game->moves);
}

static int	handle_keys(int keycode, t_game *game)
{
	if (keycode == KEY_ESC)
	{
		close_window(game);
		exit(0);
	}
	else if (keycode == KEY_W)
		move_player(game, 0, -1);
	else if (keycode == KEY_A)
		move_player(game, -1, 0);
	else if (keycode == KEY_S)
		move_player(game, 0, 1);
	else if (keycode == KEY_D)
		move_player(game, 1, 0);
	if (game->game_over == TRUE)
	{
		ft_printf("\t%d\n", game->moves);
		close_window(game);
		exit(0);
	}
	return (0);
}

static void	find_player(t_game *game)
{
	int	y;
	int	x;

	y = 0;
	while (game->map.tiles[y])
	{
		x = 0;
		while (game->map.tiles[y][x])
		{
			if (game->map.tiles[y][x] == 'P')
			{
				game->tav.x = x;
				game->tav.y = y;
				game->tav.collected = 0;
			}
			x++;
		}
		y++;
	}
}

static int	render_game(t_game *game)
{
	load_map(game);
	return (0);
}

int	init_game(t_game *game)
{
	game->mlx = mlx_init();
	if (!game->mlx)
		return (EXIT_FAILURE);
	game->win = mlx_new_window(game->mlx, game->win_width, \
			game->win_height, game->title);
	if (!game->win)
		return (EXIT_FAILURE);
	load_textures(game);
	find_player(game);
	ft_printf("Starting moves: %d\n\n", game->moves);
	ft_printf("Moves:\n", game->moves);
	mlx_loop_hook(game->mlx, render_game, game);
	mlx_key_hook(game->win, handle_keys, game);
	mlx_hook(game->win, 17, 0, close_window, game);
	mlx_loop(game->mlx);
	return (EXIT_SUCCESS);
}
