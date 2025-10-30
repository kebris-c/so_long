/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   utils.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/09 11:45:40 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 14:53:30 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

int	ft_in_set(char c, char *set)
{
	int	i;

	if (!c || !set)
		return (EXIT_FAILURE);
	i = 0;
	while (set[i])
	{
		if (c == set[i])
			return (EXIT_SUCCESS);
		i++;
	}
	return (EXIT_FAILURE);
}

int	ft_erase_all(t_game *game)
{
	if (!game)
		return (0);
	if (game->floor.ptr)
		mlx_destroy_image(game->mlx, game->floor.ptr);
	if (game->collect.ptr)
		mlx_destroy_image(game->mlx, game->collect.ptr);
	if (game->player.ptr)
		mlx_destroy_image(game->mlx, game->player.ptr);
	if (game->wall.ptr)
		mlx_destroy_image(game->mlx, game->wall.ptr);
	if (game->exit.ptr)
		mlx_destroy_image(game->mlx, game->exit.ptr);
	if (game->win)
		mlx_destroy_window(game->mlx, game->win);
	if (game->mlx)
	{
		mlx_destroy_display(game->mlx);
		free(game->mlx);
	}
	if (game->map.tiles)
		ft_free_matrix(game->map.tiles);
	return (0);
}

int	close_window(t_game *game)
{
	ft_printf("\nTotal moves: %d\n", game->moves);
	ft_erase_all(game);
	exit(0);
	return (0);
}

int	exit_msg(char *msg)
{
	ft_putstr_fd("Error\n", 2);
	ft_putstr_fd(msg, 2);
	ft_putchar('\n');
	return (EXIT_FAILURE);
}
