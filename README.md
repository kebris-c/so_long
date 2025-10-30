# 🧱 so_long

Project developed by **kebris-c**, student at **42 Madrid**.  
A small 2D game where the player must collect all the items before reaching the exit.  
Simple, straightforward, and with just enough pain to make debugging interesting.

---

## 📦 Dependencies

This project **requires**:

1. **libft** → You must clone or move your `libft` project into the root directory of this one.  
   Some functions used in *so_long* rely on it.

2. **MiniLibX** → The graphical library needed to compile and run the game.  
   Download the version you need from the official source:  
   👉 [https://github.com/42Paris/minilibx-linux](https://github.com/42Paris/minilibx-linux)  
   *(If you’re on macOS, grab the proper version from the same repository or your campus mirror.)*

---

## 🎮 How to Play

1. Compile the project:
   ```bash
   make
   ```

2. Run the game with a map:

   ```bash
   ./so_long maps/map1.ber
   ```

3. Controls:

   * `W` / `A` / `S` / `D` → Move the character.
   * Goal: **collect all items** and then reach the exit.
     You can only leave once every collectible has been picked up.

4. The game displays the **real-time move counter** during gameplay.

---

## 🧰 Makefile

Don’t forget to run:

```bash
make help
```

It shows all available rules, including:

* Environment normalization.
* **Debug** modes.
* **Leak** testing.
* Full clean and rebuild.

---

## 🖼️ Textures & Maps

Base textures were sourced from other 42 students’ public projects.
You’re free to replace them with any valid textures as long as they meet project requirements.

Included maps are more than enough for testing, but you can modify or create new ones to your liking.

---

## 🧠 Final Note

A small game, a big headache — but hey, that’s the fun part.
Good luck, and may your player never get stuck behind a wall again.
