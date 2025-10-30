# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kebris-c <kebris-c@student.42madrid.c      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/08 13:07:54 by kebris-c          #+#    #+#              #
#    Updated: 2025/10/30 16:01:26 by kebris-c         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

.DEFAULT_GOAL := all

.PHONY: all bonus clean fclean re \
	rigor rigor_bonus dbg dbg_bonus gdb gdb_bonus \
	re_bonus re_rigor re_rigor_bonus re_dbg re_dbg_bonus re_gdb re_gdb_bonus \
	setup help norm norm_bonus norm_libft norm_all \
	leaks leaks_bonus leaks_rigor leaks_rigor_bonus leaks_dbg leaks_dbg_bonus

SHELL := /bin/bash

# 📚 Basic project variables
#	Notes:
#		P = PROJECT ; B = BONUS ; N = NAME of it's library *.a
#
PROJECT		= so_long
P_BONUS		= $(PROJECT)_bonus
P_RIGOR		= $(PROJECT)_rigor
P_B_RIGOR	= $(PROJECT)_rigor_bonus
P_DBG		= $(PROJECT)_dbg
P_B_DBG		= $(PROJECT)_dbg_bonus
P_GDB		= $(PROJECT)_gdb
P_B_GDB		= $(PROJECT)_gdb_bonus

NAME		= $(PROJECT).a
N_BONUS		= $(P_BONUS).a
N_RIGOR		= $(P_RIGOR).a
N_B_RIGOR	= $(P_B_RIGOR).a
N_DBG		= $(P_DBG).a
N_B_DBG		= $(P_B_DBG).a
N_GDB		= $(P_GDB).a
N_B_GDB		= $(P_B_GDB).a

#	Special project variables
#
MLX_DIR	= ./minilibx-linux/
MLX 	= $(MLX_DIR)libmlx.a
MLX2	= $(MLX_DIR)libmlx_Linux.a
MLXFLAG	= -L$(MLX_DIR) -lmlx_Linux -lXext -lX11 -lm -lz

# 🔧 Compiler and flags
#
CC			= cc
CFLAGS		= -Wall -Wextra -Werror
CEXTRAFLAGS	= \
			$(CFLAGS) \
			-MMD \
			-MP \
			-std=c17 \
			-Wpedantic \
			-Wconversion \
			-Wsign-conversion \
			-Wshadow \
			-Wstrict-prototypes \
			-Wpointer-arith \
			-Wcast-align \
			-Wunreachable-code \
			-Winit-self \
			-Wswitch-enum \
			-Wfloat-equal \
			-Wformat=2 \
			-Wmissing-prototypes \
			-Wmissing-declarations \
			-Wdouble-promotion \
			-Wundef \
			-Wbad-function-cast \
			-Winline -Wvla \
			-Wno-unused-parameter \
			-Wno-missing-field-initializers \
			-fstrict-aliasing \
			-fstack-protector-strong \
			-D_FORTIFY_SOURCE=2 \
			-g3 \
			-O0
GDBFLAGS	= \
			  $(CFLAGS) \
			  -g3 \
			  -O0

# 🔨 Tools
#
AR      = ar rcs
RM      = rm -rf
NORM    = norminette
CP      = cp -r
LS		= ls -l

# 📂 Fast path variables / dirs
#
SRC_DIR		= src/
INCL_DIR	= include/
OBJS_DIR	= objs/
DEPS_DIR	= deps/
# If there is bonus
#
BONUS_DIR		= bonus/
B_SRC_DIR		= bonus/src/
B_INCL_DIR		= bonus/include/
B_OBJS_DIR		= bonus/objs/
B_DEPS_DIR		= bonus/deps/
# If there is Libft
#
LIB_DIR			= libft/
L_SRC_DIR		= libft/src/
L_INCL_DIR		= libft/include/
L_OBJS_DIR		= libft/objs/
L_DEPS_DIR		= libft/deps/
LIB				= $(LIB_DIR)libft.a

# 🎯 Sources, Objects and Deps	! Remember to update the list wvery project
#
SRCS	= so_long.c \
		  game.c \
		  utils.c \
		  check_valid_route.c \
		  map_checker.c \
		  map_load.c \
		  textures_load.c
OBJS	= $(patsubst %.c,$(OBJS_DIR)%.o,$(SRCS))
DEPS	= $(patsubst $(OBJS_DIR)%.o,$(DEPS_DIR)%.d,$(OBJS))
# If there is bonus...
#
B_SRCS	= $(SRCS)
B_OBJS	= $(patsubst %.c,$(B_OBJS_DIR)%.o,$(B_SRCS))
B_DEPS	= $(patsubst $(B_OBJS_DIR)%.o,$(B_DEPS_DIR)%.d,$(B_OBJS))

# 📄 Headers. First, we need to check if there is a libft dir
#
HAS_LIBFT = $(shell \
    if [ -d libft ]; then \
        echo yes; \
    else \
        echo no; \
    fi)
HEADERS = -I$(INCL_DIR)
ifeq ($(HAS_LIBFT),yes)
    HEADERS += -I$(L_INCL_DIR)
endif

# ------------------------------------------------ #
#    COMPILE COMMANDS 			                   #
# ------------------------------------------------ #
#	Notes:
#		$(1) == flags	$(2) == Dependency (library *.a)	$(3) == Executable Name
#
define COMPILE_PROJECT
	@if [ -d $(LIB_DIR) ]; then \
		$(CC) $(1) $(2) $(MLXFLAG) -L$(LIB_DIR) -lft -o $(3); \
	else \
		$(CC) $(1) $(2) $(MLXFLAG) -o $(3); \
	fi
endef

# ------------------------------------------------ #
#  Setup rule: normalize project structure         #
# ------------------------------------------------ #

setup:
	@mkdir -p $(SRC_DIR) $(INCL_DIR) $(OBJS_DIR) $(DEPS_DIR)
	@if [ -d $(BONUS_DIR) ]; then \
		mkdir -p $(B_SRC_DIR) $(B_INCL_DIR) $(B_OBJS_DIR) $(B_DEPS_DIR); \
		find . -maxdepth 1 -name "*_bonus.c" ! -path "./$(B_SRC_DIR)*" -exec mv -n {} $(B_SRC_DIR)/ \;; \
		find . -maxdepth 1 -name "*_bonus.h" ! -path "./$(B_INCL_DIR)*" -exec mv -n {} $(B_INCL_DIR)/ \;; \
		find . -maxdepth 1 -name "*_bonus.o" ! -path "./$(B_OBJS_DIR)*" -exec mv -n {} $(B_OBJS_DIR)/ \;; \
		find . -maxdepth 1 -name "*_bonus.d" ! -path "./$(B_DEPS_DIR)*" -exec mv -n {} $(B_DEPS_DIR)/ \;; \
	fi
	@find . -maxdepth 1 -name "*.c" ! -path "./$(SRC_DIR)*" -exec mv -n {} $(SRC_DIR)/ \;
	@find . -maxdepth 1 -name "*.h" ! -path "./$(INCL_DIR)*" -exec mv -n {} $(INCL_DIR)/ \;
	@find . -maxdepth 1 -name "*.o" ! -path "./$(OBJS_DIR)*" -exec mv -n {} $(OBJS_DIR)/ \;
	@find . -maxdepth 1 -name "*.d" ! -path "./$(DEPS_DIR)*" -exec mv -n {} $(DEPS_DIR)/ \;

# ------------------------------------------------ #
#  Help rule: Be user-friendly			           #
# ------------------------------------------------ #
# Make sure this rule is updated with correct data
#
help:
	@echo ""
	@echo "==================== HELP ===================="
	@echo ""
	@echo "📦 Basic build:"
	@echo "  all				-> build $(NAME) and $(PROJECT) (default)"
	@echo "  bonus				-> build $(N_BONUS) and $(P_BONUS)"
	@echo "  rigor				-> build $(N_RIGOR) and $(P_RIGOR) with extra rigorous flags"
	@echo "  rigor_bonus			-> build $(N_B_RIGOR) and $(P_B_RIGOR) with extra rigorous flags"
	@echo "  gdb				-> build $(N_GDB) and $(P_GDB). Then run gdb ./$(P_GDB)"
	@echo "  gdb_bonus			-> build $(N_B_GDB) and $(P_B_GDB). Then run gdb ./$(P_B_GDB)"
	@echo "  dbg				-> build $(N_DBG) and $(P_DBG)"
	@echo "  dbg_bonus			-> build $(N_B_DBG) and $(P_B_DBG)"
	@echo ""
	@echo "🧹 Cleaning:"
	@echo "  clean				-> remove .o and .d files (objs and deps)"
	@echo "  fclean			-> clean + remove binaries and .a"
	@echo "  re				-> full rebuild (fclean + all)"
	@echo "  re_bonus			-> full rebuild (fclean + bonus)"
	@echo "  re_rigor			-> full rebuild (fclean + rigor)"
	@echo "  re_rigor_bonus		-> full rebuild (fclean + rigor_bonus)"
	@echo "  re_gdb			-> full rebuild (fclean + gdb)"
	@echo "  re_gdb_bonus			-> full rebuild (fclean + gdb_bonus)"
	@echo "  re_dbg			-> full rebuild (fclean + dbg)"
	@echo "  re_dbg_bonus			-> full rebuild (fclean + dbg_bonus)"
	@echo ""
	@echo "🧠 Analysis & tools:"
	@echo "  norm				-> run norminette on main project"
	@echo "  norm_bonus			-> run norminette on bonus project"
	@echo "  norm_libft			-> run norminette on libft project"
	@echo "  norm_all			-> run norminette on main, bonus and libft projects"
	@echo "  leaks				-> valgrind main project"
	@echo "  leaks_bonus			-> valgrind bonus project"
	@echo "  leaks_rigor			-> valgrind rigor project"
	@echo "  leaks_rigor_bonus		-> valgrind rigor bonus project"
	@echo "  leaks_dbg			-> valgrind debug project"
	@echo "  leaks_dbg_bonus		-> valgrind debug bonus project"
	@echo ""
	@echo "📁 Project setup:"
	@echo "  setup				-> create normalized folder structure"
	@echo ""
	@echo "==============================================="
	@echo ""

-include $(DEPS)
-include $(B_DEPS)

#------------------------------------------------#
#   BASIC RULES / LIBRARY COMMANDS               #
#------------------------------------------------#

#	Basic options
#
all: $(PROJECT)

bonus: $(N_BONUS) $(P_BONUS)

rigor: $(N_RIGOR) $(P_RIGOR)

rigor_bonus: $(N_B_RIGOR) $(P_B_RIGOR)

dbg: $(N_DBG) $(P_DBG)

dbg_bonus: $(N_B_DBG) $(P_B_DBG)

gdb: $(N_GDB) $(P_GDB)
	gdb ./$(P_GDB)

gdb_bonus: $(N_B_GDB) $(P_B_GDB)
	gdb ./$(P_B_GDB)

#	Headers compilers
#
$(NAME): $(OBJS) $(MLX) | setup
	@if [ ! -f $(NAME) ] || [ $(NAME) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(NAME) $(OBJS); \
		echo "✅ $(NAME) built with main sources"; \
	else \
		echo "⏩ $(NAME) already up to date"; \
	fi

$(MLX):
	make -C $(MLX_DIR)

$(N_BONUS): $(B_OBJS) $(MLX) | setup
	@if [ ! -f $(N_BONUS) ] || [ $(N_BONUS) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_BONUS) $(B_OBJS); \
		echo "✅ $(N_BONUS) built with bonus sources"; \
	else \
		echo "⏩ $(N_BONUS) already up to date"; \
	fi

$(N_RIGOR): $(OBJS) $(MLX) | setup
	@if [ ! -f $(N_RIGOR) ] || [ $(N_RIGOR) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_RIGOR) $(OBJS); \
		echo "✅ $(N_RIGOR) built with main sources"; \
	else \
		echo "⏩ $(N_RIGOR) already up to date"; \
	fi

$(N_B_RIGOR): $(B_OBJS) $(MLX) | setup
	@if [ ! -f $(N_B_RIGOR) ] || [ $(N_B_RIGOR) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_B_RIGOR) $(OBJS); \
		echo "✅ $(N_B_RIGOR) built with bonus sources"; \
	else \
		echo "⏩ $(N_B_RIGOR) already up to date"; \
	fi

$(N_DBG): $(OBJS) $(MLX) | setup
	@if [ ! -f $(N_DBG) ] || [ $(N_DBG) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_DBG) $(OBJS); \
		echo "✅ $(N_DBG) built with main sources"; \
	else \
		echo "⏩ $(N_DBG) already up to date"; \
	fi

$(N_B_DBG): $(B_OBJS) $(MLX) | setup
	@if [ ! -f $(N_B_DBG) ] || [ $(N_B_DBG) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_B_DBG) $(OBJS); \
		echo "✅ $(N_B_DBG) built with bonus sources"; \
	else \
		echo "⏩ $(N_B_DBG) already up to date"; \
	fi

$(N_GDB): $(OBJS) $(MLX) | setup
	@if [ ! -f $(N_GDB) ] || [ $(N_GDB) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_GDB) $(OBJS); \
		echo "✅ $(N_GDB) built with bonus sources"; \
	else \
		echo "⏩ $(N_GDB) already up to date"; \
	fi

$(N_B_GDB): $(B_OBJS) $(MLX) | setup
	@if [ ! -f $(N_B_GDB) ] || [ $(N_B_GDB) -ot $? ]; then \
		if [ -d $(LIB_DIR) ]; then \
			$(MAKE) -C $(LIB_DIR); \
		fi; \
		$(AR) $(N_B_GDB) $(B_OBJS); \
		echo "✅ $(N_B_GDB) built with bonus sources"; \
	else \
		echo "⏩ $(N_B_GDB) already up to date"; \
	fi

#	Objects & bonus objects Compilers
#
$(OBJS_DIR)%.o: $(SRC_DIR)%.c | setup
	@echo "🔨 Compiling $<..."
	@if [ -d $(LIB_DIR) ]; then \
		$(MAKE) -C $(LIB_DIR); \
	fi
	@$(CC) $(CFLAGS) -MMD -MP $(HEADERS) -c $< -o $@
	@mv $(OBJS_DIR)$*.d $(DEPS_DIR)

$(B_OBJS_DIR)%.o: $(B_SRC_DIR)%.c | setup
	@echo "🔨 Compiling bonus $<..."
	@if [ -d $(LIB_DIR) ]; then \
		$(MAKE) -C $(LIB_DIR); \
	fi
	@$(CC) $(CFLAGS) -MMD -MP $(HEADERS) -c $< -o $@
	@mv $(B_OBJS_DIR)$*.d $(B_DEPS_DIR)

#	Cleaners
#
clean:
	@$(RM) $(OBJS_DIR) $(DEPS_DIR) $(B_OBJS_DIR) $(B_DEPS_DIR) $(L_OBJS_DIR) $(L_DEPS_DIR)

fclean: clean
	@$(RM) $(MLX) $(MLX2) \
		$(NAME) $(N_BONUS) $(LIB) $(N_DBG) $(N_B_DBG) $(N_RIGOR) $(N_B_RIGOR) $(N_GDB) $(N_B_GDB) \
		$(PROJECT) $(P_BONUS) $(P_DBG) $(P_B_DBG) $(P_RIGOR) $(P_B_RIGOR) $(P_GDB) $(P_B_GDB)

#	Reworks from zero
#
re: fclean all

re_bonus: fclean bonus

re_rigor: fclean rigor

re_rigor_bonus: fclean rigor_bonus

re_gdb: fclean gdb

re_gdb_bonus: fclean gdb_bonus

re_dbg: fclean dbg

re_dbg_bonus: fclean dbg_bonus

#------------------------------------------------#
#   PROJECT COMPILATION                          #
#------------------------------------------------#

$(PROJECT): $(NAME)
	@if [ ! -f $(PROJECT) ] || [ $(PROJECT) -ot $(NAME) ]; then \
		echo "🔄 Building $(PROJECT)..."; \
	else \
		echo "⏩ $(PROJECT) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm
	$(call COMPILE_PROJECT,$(CFLAGS),$(NAME),$(PROJECT))
	@if [ -f $(PROJECT) ]; then \
		echo "✅ $(PROJECT) linked"; \
	else \
		echo "⚠️ Failed to build $(PROJECT)"; \
	fi

$(P_BONUS): $(N_BONUS)
	@if [ ! -f $(P_BONUS) ] || [ $(P_BONUS) -ot $(N_BONUS) ]; then \
		echo "🔄 Building $(P_BONUS)..."; \
	else \
		echo "⏩ $(P_BONUS) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm_bonus
	$(call COMPILE_PROJECT,$(CFLAGS),$(N_BONUS),$(P_BONUS))
	@if [ -f $(P_BONUS) ]; then \
		echo "✅ $(P_BONUS) linked"; \
	else \
		echo "⚠️ Failed to build $(P_BONUS)"; \
	fi

$(P_RIGOR): $(N_RIGOR)
	@if [ ! -f $(P_RIGOR) ] || [ $(P_RIGOR) -ot $(N_RIGOR) ]; then \
		echo "🔄 Building $(P_RIGOR)..."; \
	else \
		echo "⏩ $(P_RIGOR) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm
	$(call COMPILE_PROJECT,$(CEXTRAFLAGS),$(N_RIGOR),$(P_RIGOR))
	@if [ -f $(P_RIGOR) ]; then \
		echo "✅ $(P_RIGOR) linked"; \
	else \
		echo "⚠️ Failed to build $(P_RIGOR)"; \
	fi

$(P_B_RIGOR): $(N_B_RIGOR)
	@if [ ! -f $(P_B_RIGOR) ] || [ $(P_B_RIGOR) -ot $(N_B_RIGOR) ]; then \
		echo "🔄 Building $(P_B_RIGOR)..."; \
	else \
		echo "⏩ $(P_B_RIGOR) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm_bonus
	$(call COMPILE_PROJECT,$(CEXTRAFLAGS),$(N_B_RIGOR),$(P_B_RIGOR))
	@if [ -f $(P_B_RIGOR) ]; then \
		echo "✅ $(P_B_RIGOR) linked"; \
	else \
		echo "⚠️ Failed to build $(P_B_RIGOR)"; \
	fi

$(P_GDB): $(N_GDB)
	@if [ ! -f $(P_GDB) ] || [ $(P_GDB) -ot $(N_GDB) ]; then \
		echo "🔄 Building $(P_GDB)..."; \
	else \
		echo "⏩ $(P_GDB) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm
	$(call COMPILE_PROJECT,$(GDBFLAGS),$(N_GDB),$(P_GDB))
	@if [ -f $(P_GDB) ]; then \
		echo "✅ $(P_GDB) linked"; \
	else \
		echo "⚠️ Failed to build $(P_GDB)"; \
	fi

$(P_B_GDB): $(N_B_GDB)
	@if [ ! -f $(P_B_GDB) ] || [ $(P_B_GDB) -ot $(N_B_GDB) ]; then \
		echo "🔄 Building $(P_B_GDB)..."; \
	else \
		echo "⏩ $(P_B_GDB) already up to update"; \
		exit 1; \
	fi
	$(MAKE) norm
	$(call COMPILE_PROJECT,$(GDBFLAGS),$(N_B_GDB),$(P_B_GDB))
	@if [ -f $(P_B_GDB) ]; then \
		echo "✅ $(P_B_GDB) linked"; \
	else \
		echo "⚠️ Failed to build $(P_B_GDB)"; \
	fi

$(P_DBG): $(N_DBG)
	@if [ ! -f $(P_DBG) ] || [ $(P_DBG) -ot $(N_DBG) ]; then \
		echo "🔄 Building $(P_DBG)..."; \
		if [ -d $(LIB_DIR) ]; then \
			$(CC) $(N_DBG) $(MLXFLAG) -L$(LIB_DIR) -lft -o $(P_DBG); \
		else \
			$(CC) $(N_DBG) $(MLXFLAG) -o $(P_DBG); \
		fi; \
		if [ -f $(P_DBG) ]; then \
			echo "✅ $(P_DBG) linked"; \
		else \
			echo "⚠️ Failed to build $(P_DBG)"; \
		fi; \
	else \
		echo "⏩ $(P_DBG) already up to update"; \
	fi

$(P_B_DBG): $(N_B_DBG)
	@if [ ! -f $(P_B_DBG) ] || [ $(P_B_DBG) -ot $(N_B_DBG) ]; then \
		echo "🔄 Building $(P_B_DBG)..."; \
		if [ -d $(LIB_DIR) ]; then \
			$(CC) $(N_B_DBG) $(MLXFLAG) -L$(LIB_DIR) -lft -o $(P_B_DBG); \
		else \
			$(CC) $(N_B_DBG) $(MLXFLAG) -o $(P_B_DBG); \
		fi; \
		if [ -f $(P_B_DBG) ]; then \
			echo "✅ $(P_B_DBG) linked"; \
		else \
			echo "⚠️ Failed to build $(P_B_DBG)"; \
		fi; \
	else \
		echo "⏩ $(P_B_DBG) already up to update"; \
	fi

#------------------------------------------------#
#   NORMINETTE & LEAKS                           #
#------------------------------------------------#

norm:
	@if $(NORM) $(INCL_DIR) $(SRC_DIR) 2>/dev/null; then \
		exit 0; \
	else \
		exit 1; \
	fi

norm_bonus:
	@if $(NORM) $(B_INCL_DIR) $(B_SRC_DIR) 2>/dev/null; then \
		exit 0; \
	else \
		exit 1; \
	fi

norm_libft:
	@if $(NORM) $(L_INCL_DIR) $(L_SRC_DIR) 2>/dev/null; then \
		exit 0; \
	else \
		exit 1; \
	fi

norm_all: norm norm_bonus norm_libft

leaks: $(PROJECT)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(PROJECT) || true

leaks_bonus: $(P_BONUS)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(P_BONUS) || true

leaks_rigor: $(P_RIGOR)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(P_RIGOR) || true

leaks_rigor_bonus: $(P_B_RIGOR)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(P_B_RIGOR) || true

leaks_dbg: $(P_DBG)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(P_DBG) || true

leaks_dbg_bonus: $(P_B_DBG)
	@valgrind --leak-check=full --show-leak-kinds=all ./$(P_B_DBG) || true

# Dinamic version of .PHONY
#
#.PHONY: $(filter-out $(NAME) $(PROJECT) bonus_$(PROJECT), $(MAKECMDGOALS))
