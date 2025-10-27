Draft Version of read.me file, please check and see what you would like to keep
#AI was used in this assignment; it was copied and rewritten when appropriate.

# Auckland Dairy Simulator  
**Semester 2, 2025 – Team W204**

---

##  Project Overview
Auckland Dairy Simulator is a narrative-driven management game built in **Godot 4.5**.  
Players manage a dairy shop, interact with customers (NPCs), and make choices that affect story outcomes and replayability.  

---

## Key Features (Sprint 2)
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
- **NPC System:**  
  NPCs appear depending on in-game days and player actions.

---

## Technical Summary
**Engine:** Godot 4.5  
**Language:** GDScript  
**Database/Storage:** JSON via Godot’s File API  
**Version Control:** Git + GitHub  
**Testing Framework:** GUT (Godot Unit Test)

---

## How to Run the Project
1. Open the folder in **Godot 4.5**.  
2. Go to `Project → run`
3. Project should allow itself to be played

---

## Saving & Loading
- Use **Save** or **Load** buttons in the Pause Menu.
- Use can **Load** old saves of **Save** your current position to come back latter

---  

## Team
- **Team W204** – Auckland University of Technology
- Product Owner: Dhon Lao
- Scrum Master: Liam Wiggill
- Development Team: Raghav Bhalla, Ciaran Crane

---

## Dependencies
- Godot 4.5+
- GUT (Godot Unit Test)
- Git / GitHub

---

## License
This project is for educational use only (COMP602 coursework).  
All assets used fall under fair use for academic purposes.

