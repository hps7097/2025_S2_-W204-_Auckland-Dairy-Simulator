Draft Version of read.me file, please check and see what you would like to keep
#AI was used in this assignment; it was copied and rewritten when appropriate.

# Auckland Dairy Simulator 🥛  
**Semester 2, 2025 – Team W204**

---

## 🎮 Project Overview
Auckland Dairy Simulator is a narrative-driven management game built in **Godot 4.5**.  
Players manage a dairy shop, interact with customers (NPCs), and make choices that affect story outcomes and replayability.  
The project emphasizes **Test-Driven Development (TDD)**, **design patterns**, and **team collaboration** across three sprints.

---

## 🧩 Key Features (Sprint 2)
- **Save & Load System:**  
  Persistent saves stored as JSON in `user://saves/`.  
  Accessible from the **Main**, **Pause**, and **Options** menus.
- **Ending Manager:**  
  Determines different endings (Good, Neutral, Bad) based on player decisions.  
  Displays a result screen at the end of each run.
- **Dialogue System:**  
  Branching choices that change flags and player stats.
- **Replay Value:**  
  Each playthrough influences the next; choices directly affect endings.
- **Audio System (planned):**  
  Background music and sound effects managed by `AudioManager.gd`.
- **Achievements Menu (planned):**  
  Unlock and display milestones in-game.
- **NPC System:**  
  NPCs appear depending on in-game days and player actions.

---

## 🧠 Technical Summary
**Engine:** Godot 4.5  
**Language:** GDScript  
**Database/Storage:** JSON via Godot’s File API  
**Version Control:** Git + GitHub  
**Testing Framework:** GUT (Godot Unit Test)

---

## 🧪 How to Run the Project
1. Open the folder in **Godot 4.5**.  
2. Go to `Project → Project Settings → Autoload` and ensure these singletons are added:
3. Set the **Main Scene** to `scenes/MainMenu.tscn`.  
4. Press ▶ to run.

---

## 💾 Saving & Loading
- Use **Save** or **Load** buttons in the Pause Menu.  
- Files are saved in:  

- You can manually rename or create new saves for testing.

---

## 🧩 Endings
- Each session’s choices are logged in `GameState.runs`.  
- At completion, `EndingManager` evaluates the result and loads `EndingScreen.tscn`.  
- The screen shows the result (`GOOD`, `NEUTRAL`, or `BAD`) and returns to the main menu.

---

## 🧠 Testing (TDD & GUT)
1. **Enable GUT Plugin:**  
 Project → Plugins → Enable “GUT”.
2. Open `addons/gut/GutScene.tscn`.
3. Set the test directory to `res://tests/`.
4. Run all tests → expect ✅  
 - `TestDialogue.gd` – verifies that dialogue choices apply effects and flags.  
 - `TestUpgrades.gd` – ensures upgrades are stored and retrievable in GameState.

---

## 📂 Project Structure


---

## 👥 Team
- **Team W204** – Auckland University of Technology
- Product Owner: Dhon Lao
- Scrum Master: Liam Wiggill
- Development Team: Raghav Bhalla, Ciaran Crane

---

## 🧩 Dependencies
- Godot 4.5+
- GUT (Godot Unit Test)
- Git / GitHub

---

## 🧾 License
This project is for educational use only (COMP602 coursework).  
All assets used fall under fair use for academic purposes.

