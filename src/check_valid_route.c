/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   check_valid_route.c                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/09 14:56:03 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 13:39:30 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "so_long.h"

static void	flood_fill(t_map map, int y, int x, t_items *recheck)
{
	if (x < 0 || y < 0 || y >= map.height || x >= map.width)
		return ;
	else if (map.tiles[y][x] == '1' || map.tiles[y][x] == '2')
		return ;
	else if (map.tiles[y][x] == 'E')
		return ;
	else if (map.tiles[y][x] == 'C')
		recheck->collects++;
	map.tiles[y][x] = '2';
	flood_fill(map, y, x + 1, recheck);
	flood_fill(map, y, x - 1, recheck);
	flood_fill(map, y + 1, x, recheck);
	flood_fill(map, y - 1, x, recheck);
}

static int	check_items_on_road(t_map map)
{
	int	y;
	int	x;

	y = 0;
	while (map.tiles[y])
	{
		x = 0;
		while (map.tiles[y][x])
			if (map.tiles[y][x++] == 'C')
				return (EXIT_FAILURE);
		y++;
	}
	return (EXIT_SUCCESS);
}

int	check_valid_route(t_map map, t_items *check)
{
	t_items	*recheck;
	int		x;
	int		y;

	recheck = check;
	recheck->exit = 0;
	recheck->collects = 0;
	y = 0;
	while (map.tiles[y])
	{
		x = 0;
		while (map.tiles[y][x])
		{
			if (map.tiles[y][x] == 'P')
				flood_fill(map, y, x, recheck);
			x++;
		}
		y++;
	}
	if (recheck->collects != check->collects)
		return (EXIT_FAILURE);
	if (check_items_on_road(map) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	return (EXIT_SUCCESS);
}
