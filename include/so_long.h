/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   so_long.h                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/08 19:32:14 by kebris-c          #+#    #+#             */
/*   Updated: 2025/10/29 14:53:42 by kebris-c         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef SO_LONG_H
# define SO_LONG_H

/* ************************************************************************** */
/*	Headers																	  */
/* ************************************************************************** */
# include "libft/include/libft.h"
# include <X11/keysym.h>
# include "minilibx-linux/mlx.h"

/* ************************************************************************** */
/*	Structures																  */
/* ************************************************************************** */
typedef struct s_map
{
	char	**tiles;
	int		width;
	int		height;
	int		total_collects;
}	t_map;

typedef struct s_img
{
	void	*ptr;
	int		width;
	int		height;
}	t_img;

typedef struct s_player
{
	int	x;
	int	y;
	int	collected;
}	t_player;

typedef struct s_game
{
	void		*mlx;
	void		*win;
	int			win_width;
	int			win_height;
	int			tile_size;
	char		*title;

	t_map		map;

	t_player	tav;

	t_img		wall;
	t_img		floor;
	t_img		player;
	t_img		exit;
	t_img		collect;

	t_bool		game_over;

	int			moves;
}	t_game;

typedef struct s_items
{
	int	player;
	int	collects;
	int	exit;
}	t_items;

/* ************************************************************************** */
/*	Inline functions														  */
/* ************************************************************************** */
static inline char	top_right(t_map *map)
{
	return (map->tiles[map->height - 1][map->width - 1]);
}

static inline char	bottom_right(t_map *map)
{
	return (map->tiles[map->height - 1][0]);
}

static inline char	bottom_left(t_map *map)
{
	return (map->tiles[0][0]);
}

static inline char	top_left(t_map *map)
{
	return (map->tiles[0][map->width - 1]);
}

static inline char	*get_texture(char *item)
{
	return (ft_strjoin("textures/", item));
}

/* ************************************************************************** */
/*	Defines																	  */
/* ************************************************************************** */
# define KEY_ESC	65307
# define KEY_W		119
# define KEY_A		97
# define KEY_S		115
# define KEY_D		100

/* ************************************************************************** */
/*	Functions declaration													  */
/* ************************************************************************** */
int		map_checker(t_map *map, t_map mapcpy);
int		ft_erase_all(t_game *game);
int		ft_in_set(char c, char *set);
int		check_valid_route(t_map map, t_items *check);
int		init_game(t_game *game);
int		exit_msg(char *msg);
int		close_window(t_game *game);
void	load_textures(t_game *game);
void	load_map(t_game *game);
t_map	ft_mapcpy(t_map map);

//void	ft_debugger(t_map map);

#endif
