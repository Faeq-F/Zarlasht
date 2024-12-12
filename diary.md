# Diary

<details><summary>Term 1</summary>

<details><summary>Week 12</summary>

### 11/12/2024 - 13/12/2024

Converted the screen designs for the final game into Lustre for easier
development next term. Practicing for my presentation. Finalizing my interim
report. Adding forgotten pieces to the repository and report.

### 08/12/2024 - 10/12/2024

Converted my UML diagrams to be digital and finished producing a draft for my
interim report to get feedback from my supervisor.

</details>

<details><summary>Week 11</summary>

### 05/12/2024 - 07/12/2024

Continued with the Pong PoC - shifting focus on deployable implementation to one
that can show that the technologies used are versatile (and not hard-coded for
one game) (this was the original intention of having this game planned).
Continued writing up the interim report; mostly making incoherent notes for now.

### 01/12/2024 - 04/12/2024

Cleaned up the fix to the error from last week and optimized it for the final
game; made it reusable so that it can be transplanted into the Pong PoC and
final game. Completed the tic-tac-toe PoC targeting Erlang.

</details>

<details><summary>Week 10</summary>

### 28/11/2024 - 30/11/2024

Trying to fix error relating to not using the owner process of a websocket
connection to send messages. Taking inspiration from
[chatter-reborn](https://github.com/connellr023/chatter-reborn) on how to use
actors for high concurrency.

### 23/11/2024 - 27/11/2024

Added Valkey and WebSocket connections to the Pong game. Also added the
`FLUSHDB` command for Valkey, and HTMX message interpretation for the
tic-tac-toe PoC targeting Erlang.

</details>

<details><summary>Week 9</summary>

### 20/11/2024 - 22/11/2024

Started the Pong PoC. Tried using Wisp but swapped it out for Mist due to the
state of websockets on the framework. Also started the interim report.

### 17/11/2024 - 19/11/2024

Completed the tic-tac-toe PoC targeting javascript - aiming to translate
javascript PoCs into erlang while developing the pong PoC to help with
understanding key differences between the targets.

</details>

<details><summary>Week 8</summary>

### 14/11/2024 - 16/11/2024

Completed the online chat PoC targeting javascript, with messages saving to the
database aswell so that new users in a chat can see old messages. Started to
finish off the tic-tac-toe PoC targeting javascript. Will work on the pong PoC,
targeting Erlang, in parallel.

### 09/11/2024 - 13/11/2024

Shifting focus for PoCs to functional programs targeting Erlang, after a meeting
with my supervisor; no longer doing concurrency testing and comparing targets. I
have chosen to finish off the PoCs that target javascript, that have already
been started, to help focus on familiarising myself with the technologies the
targets share before facing the ones they do not.

Produced chat page for online chat PoC and implemented message publishing

</details>

<details><summary>Week 7</summary>

### 07/11/2024 - 08/11/2024

Testing the Pub / Sub functions and interactions with websockets. Ensuring all
relevant end-to-end communications can be made

### 04/11/2024 - 06/11/2024

Researched into and implemented FFI functions for the Pub / Sub design pattern

</details>

<details><summary>Week 6</summary>

### 30/10/2024 - 01/11/2024

Looked into the Chrobot documentation and learnt how to write the
automated-browser tests (was a little confused on using the Chrome DevTools
protocols)

### 28/10/2024 - 30/10/2024

Research into testing web frontends and middleware. Setup automated-browser
testing through Chrobot

</details>

<details><summary>Week 5</summary>

### 23/10/2024 - 25/10/2024

Setup Incremental Interactive Unit Testing in the gleam project and tested use
of the server request handler

### 21/10/2024 - 23/10/2024

Setup the gleam project for online chat (targeting javascript) and created the
home page with websocket messaging

</details>

<details><summary>Week 4</summary>

### 17/10/2024 - 21/10/2024

Making screen designs something that will be worked on during the work on the
rest of the goals on the timeline (this will help with understanding how to
build what I want with my technologies).

Having a look at concurrency testing programs and a means to do TDD &
documentation with my chosen technologies (I know you can do so (and well), but
I just need to learn how).

### 14/10/2024 - 16/10/2024

Setting up the technologies for my project on my machine (WSL, Deno, Gleam,
etc.). Finishing off my screen designs.

</details>

<details><summary>Week 3</summary>

### 08/10/2024 - 11/10/2024

Got more feedback from my supervisor for my project plan & made the
improvements. Continued with screen designs & did further research into my
chosen technologies (specifically Gleam) due to a misunderstanding of it's
implementation of concurrency.

### 07/10/2024 - 08/10/2024

Finished improving the project plan. I have also setup hosting for the final
program and all of the proof of concepts that will be produced. This includes
deno deploy for the websocket servers and aiven for the Valkey database.

</details>

<details><summary>Week 2</summary>

### 02/10/2024 - 07/10/2024

Began digitizing the screen designs and started to learn how to use Valkey &
radish (database & client) for the final game. Also, after a meeting with my
supervisor, I am improving my project plan.

### 30/09/2024 - 01/10/2024

Drew the screen designs and program architecture diagrams for the final game.

</details>

<details><summary>Week 1</summary>

### 23/09/2024 - 27/09/2024

Produced the project plan and did research on viable technologies for concurrent
environments.

</details>

</details>
