# Diary

<details><summary>Term 2</summary>

<details><summary>Week 8</summary>

### 04/03/2025 - 05/03/2025

Updated the ReadMe files for all projects to include the directory descriptions and noted the interesting files, as suggested in the feedback.
(goal 14)

Continued to work on the final report, consolidating ideas about how to write the newer sections, like distribution, implementation of the final system, etc.

</details>

<details><summary>Week 7</summary>

### 28/02/2025 - 03/03/2025

Started to focus on the final report. Laid out what I wish to write about in the new sections and how I will add what was suggested in my feedback to pre-existing sections.

### 25/02/2025 - 27/02/2025

Produced the created_game, join_game and set_name pages, alongside transplanting the leaderboard from the Pong prototype.
Made the leaderboard suitable for the game, modifying the construction functions to accept and use the game data correctly.
Tested it with sample data. (aim 3, 6 & 7; goals 10 & 11)

</details>

<details><summary>Week 6</summary>

### 21/02/2025 - 24/02/2025

Concluded the creation of the bottom bar & will now shift focus to quickly creating the rest of the pages for the game so that I can move onto more advanced functionalities.
(aim 6 & 7; goal 10)

### 18/02/2025 - 20/02/2025

Added Alpine.js to help with producing the UI, ensuring it is only used for a single client's local state 
(like whether or not they are looking at the information modal - processing for the game should be done on the server) 
Continued to produce the bottom bar and related UI that requires its use.
(aim 6 & 7; goal 10)

</details>

<details><summary>Week 5</summary>

### 13/02/2025 - 17/02/2025

Continued to fix the issues with the UI. Focusing on the bottom bar - has all of the functionality for the user to play the game (input fields, buttons, etc.)
(aim 6 & 7; goal 10)

### 11/02/2025 - 12/02/2025

Ran into some hurdles creating the pages in a reusable, modular way. Switched back to the screen_designs project to help simplify the process.
Continued to produce the pages and refactor old ones so that elements are separated into components that are reusable.
(aim 6 & 7; goal 10)

</details>

<details><summary>Week 4</summary>

### 07/02/2025 - 10/02/2025

Continued to adapt old screen designs to produce usable pages that can display all that is needed for the game (like a map, chat, etc.)
(aim 6; goal 10)

### 04/02/2025 - 06/02/2025

Transplanted old components from other projects (the prototypes) into the final game.
(aim 7; goal 8) Also started to finish off the screen designs from last term.

</details>

<details><summary>Week 3</summary>

### 30/01/2025 - 03/02/2025

Refactored the game page and game actor to help with readability and reusability - will be helpful for reproducing the use of the text field in messages in the final game, if needed. (aim 7; goal 8)

Also setup the project for the final game.

### 27/01/2025 - 29/01/2025

Moving JS dependant code to the server will have to be sidelined. The general 
principle of how to do this is now completely understood; I can make further improvements like using a style attribute on the paddle element and re-render using 
htmx, instead of injecting JS to update the properties, but since this is understood, I will attempt to save time and move onto newer concerns.

I am now focusing on testing the prototypes. This probably will not be complete,
but as long as I have the general idea, I can implement tests for the base functionality that was missed during the interim submission, and then focus on 
the final game. (aims 5 & 7; goal 8)

I am also improving my work based off the interim submission feedback. E.g., 
I have started to refer to my original plan explicitly, using milestones names/number,
in this diary, updating old entries.

</details>

<details><summary>Week 2</summary>

### 23/01/2025 - 26/01/2025

Added a reusable feature to the Pong prototype - a leaderboard. Started with a 
simple overlay and design, then moved to dynamic creation of the board, and then 
dynamic creation based off values from the ETS table. (goal 9)

Will need to implement the Valkey dependency. This will work the same for all prototypes, so I will only implement it for the Pong game to save on time.

Also simplified the director actor since games do not need codes, like the 
other prototypes require them to.

### 21/01/2025 - 22/01/2025

Continued moving processing to the server. Created an input field to be 
filled and sent to the server on every game action to make this easier and 
maintain minimal client code (since JS is single threaded). (as planned for weeks 1-2; aim 4 and goal 9)

</details>

<details><summary>Week 1</summary>

### 16/01/2025 - 20/01/2025

Moved some of the JS dependant code for the Pong prototype to the Gleam server
so that less processing is done client side. Will attempt to move all processing
to the server, like the other prototypes' implementations. (ensuring aims 3, 4 and 5 are met; goals 7 & 8)

### 13/01/2025 - 15/01/2025

Continued to make improvements to the Pong prototype. Updated the enter screens
and game styling so that the game plays as expected - on a single machine. (as planned for weeks 1-2; aims 3 & 6; goals 2, 7 & 8)

</details>

</details>

<details><summary>Term 1</summary>

<details><summary>Week 12</summary>

### 11/12/2024 - 13/12/2024

Converted the screen designs for the final game into Lustre for easier
development next term. Practicing for my presentation. Finalizing my interim
report. Adding forgotten pieces to the repository and report (aims 5 & 7; goals 8 & 9).

### 08/12/2024 - 10/12/2024

Converted my UML diagrams to be digital and finished producing a draft for my
interim report to get feedback from my supervisor. (as planned for week 9; ensuring
goals 1 & 5 are met)

</details>

<details><summary>Week 11</summary>

### 05/12/2024 - 07/12/2024

Continued with the Pong PoC - shifting focus on deployable implementation to one
that can show that the technologies used are versatile (and not hard-coded for
one game) (this was the original intention of having this game planned).
Continued writing up the interim report; mostly making incoherent notes for now.
(as planned for week 7, 8 and 9; aims 3 & 7; goals 7, 8 & 9)

### 01/12/2024 - 04/12/2024

Cleaned up the fix to the error from last week and optimized it for the final
game; made it reusable so that it can be transplanted into the Pong PoC and
final game. Completed the tic-tac-toe PoC targeting Erlang. (as planned for week 6 & 8;
aim 3; goals 6, 8 & 9)

</details>

<details><summary>Week 10</summary>

### 28/11/2024 - 30/11/2024

Trying to fix error relating to not using the owner process of a websocket
connection to send messages. Taking inspiration from
[chatter-reborn](https://github.com/connellr023/chatter-reborn) on how to use
actors for high concurrency. (goals 3, 7, 8 & 9; aims 1, 3 & 4)

### 23/11/2024 - 27/11/2024

Added Valkey and WebSocket connections to the Pong game. Also added the
`FLUSHDB` command for Valkey, and HTMX message interpretation for the
tic-tac-toe PoC targeting Erlang. (goals 2, 4, 7 & 8)

</details>

<details><summary>Week 9</summary>

### 20/11/2024 - 22/11/2024

Started the Pong PoC (as planned for week 7). Tried using Wisp but swapped it out for Mist due to the
state of websockets on the framework. Also started the interim report.

### 17/11/2024 - 19/11/2024

Completed the tic-tac-toe PoC targeting javascript (goal 6) - aiming to translate
javascript PoCs into erlang while developing the pong PoC to help with
understanding key differences between the targets.

</details>

<details><summary>Week 8</summary>

### 14/11/2024 - 16/11/2024

Completed the online chat PoC targeting javascript, with messages saving to the
database aswell so that new users in a chat can see old messages. Started to
finish off the tic-tac-toe PoC targeting javascript. Will work on the pong PoC,
targeting Erlang, in parallel. (as planned for weeks 6 & 7; goals 6, 7 & 8; aim 3)

### 09/11/2024 - 13/11/2024

Shifting focus for PoCs to functional programs targeting Erlang, after a meeting
with my supervisor; no longer doing concurrency testing and comparing targets. I
have chosen to finish off the PoCs that target javascript, that have already
been started, to help focus on familiarizing myself with the technologies the
targets share before facing the ones they do not. (goal 3, 6 & 7; ensuring aim 4 & 7)

Produced chat page for online chat PoC and implemented message publishing. (as planned for week 5)

</details>

<details><summary>Week 7</summary>

### 07/11/2024 - 08/11/2024

Testing the Pub / Sub functions and interactions with websockets. Ensuring all
relevant end-to-end communications can be made (aims 1 & 2, goals 2, 4 & 5)

### 04/11/2024 - 06/11/2024

Researched into and implemented FFI functions for the Pub / Sub design pattern
(goals 3, 4 & 5; aims 2 & 5)

</details>

<details><summary>Week 6</summary>

### 30/10/2024 - 01/11/2024

Looked into the Chrobot documentation and learnt how to write the
automated-browser tests (was a little confused on using the Chrome DevTools
protocols) (goal 3)

### 28/10/2024 - 30/10/2024

Research into testing web frontends and middleware. Setup automated-browser
testing through Chrobot (goal 3)

</details>

<details><summary>Week 5</summary>

### 23/10/2024 - 25/10/2024

Setup Incremental Interactive Unit Testing in the gleam project and tested use
of the server request handler (goal 3)

### 21/10/2024 - 23/10/2024

Setup the gleam project for online chat (targeting javascript) and created the
home page with websocket messaging (as planned for week 5; goal 6)

</details>

<details><summary>Week 4</summary>

### 17/10/2024 - 21/10/2024

Making screen designs something that will be worked on during the work on the
rest of the goals on the timeline (this will help with understanding how to
build what I want with my technologies).

Having a look at concurrency testing programs and a means to do TDD &
documentation with my chosen technologies (I know you can do so (and well), but
I just need to learn how). (goal 3)

### 14/10/2024 - 16/10/2024

Setting up the technologies for my project on my machine (WSL, Deno, Gleam,
etc.). Finishing off my screen designs. (goals 2, 3, 4)

</details>

<details><summary>Week 3</summary>

### 08/10/2024 - 11/10/2024

Got more feedback from my supervisor for my project plan & made the
improvements. Continued with screen designs & did further research into my
chosen technologies (specifically Gleam) due to a misunderstanding of it's
implementation of concurrency (aims 4 & 7, and goals 2, 3, 4).

### 07/10/2024 - 08/10/2024

Finished improving the project plan. I have also setup hosting for the final
program and all of the proof of concepts that will be produced. This includes
deno deploy for the websocket servers and Aiven for the Valkey database (as planned for week 4).

</details>

<details><summary>Week 2</summary>

### 02/10/2024 - 07/10/2024

Began digitizing the screen designs (ensuring aim 6 is met) and started to learn how to use Valkey &
radish (database & client) for the final game (goal 4). Also, after a meeting with my
supervisor, I am improving my project plan.

### 30/09/2024 - 01/10/2024

Drew the screen designs and program architecture diagrams for the final game. (as planned for week 3, ensuring aims 1, 2, 3, 4, 5 and goal 5 can be met).

</details>

<details><summary>Week 1</summary>

### 23/09/2024 - 27/09/2024

Produced the project plan and did research on viable technologies for concurrent
environments (as planned for Week 1-2).

</details>

</details>
