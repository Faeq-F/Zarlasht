# Final Year Project

Created during the 2024-2025 CS3821 module 'Final Year Project - Full Unit' at
Royal Holloway, University of London.

Project Chosen: &nbsp;A concurrency based game environment<br> Project Title:
&nbsp;&nbsp;TBD

### Repository Structure

Code for different parts of the project, and the different reports produced, are
in their respective folders, worked on in their respective branches.<br><br> See
below, an example of the repository structure (excluding feature-branches,
etc.), and the file structure of the main branch;

<details><summary>Example of repository file structure</summary>
<!-- prettier-ignore-start -->

```
root
├── documents
│   └── ... (code)
├── product
│   ├── proof_of_concepts
│   │   │
│   │   ├── online_chat
│   │   │   └── ... (code)
│   │   │
│   │   ├── tic-tac-toe_(board_game)
│   │   │   └── ... (code)
│   │   │
│   │   └── pong_(game)
│   │       └── ... (code)
│   │
│   └── zarlasht_(final_game)
│       └── ... (code)
│
├── README.md
└── diary.md
```

<!-- prettier-ignore-end -->
</details>

<details><summary>Example git graph for a single deliverable's history</summary>

<br>

Everything is worked on in their respective branches.<br> All products and
documents have their own 'main' branch, as shown below.<br> All of these 'main'
branches will be merged to main to create a deliverable for the markers.

```mermaid
%%{
    init: {
         'logLevel': 'debug',
          'theme': 'base',
          'themeVariables': {
            'primaryColor': '#fff',
            'primaryTextColor': '#000',
            'primaryBorderColor': '#eee',
            'lineColor': '#ddd',
            'secondaryColor': '#ddd',
            'tertiaryColor': '#eee'
            },
           'gitGraph': {
            'showBranches': true,
            'showCommitLabel':true,
            'mainBranchName': 'main'
        }
    }
}%%
gitGraph TB:
    commit id:"Initial commit"
    branch plan
    branch poc-online_chat
    branch poc-pong
    branch poc-tictactoe
    branch zarlasht
    branch interim
    checkout main
    commit id:"Update to diary.md"
    checkout plan
    commit id:"Example commit1"
    commit id:"Example commit2"
    checkout main
    commit id:"Added log to diary"
    commit id:"throughout the project"
    checkout interim
    commit id:"Example commit3"
    commit id:"Example commit4"
    commit id:"completed submission"
    branch final
    checkout poc-online_chat
    commit id:"Example commit5"
    commit id:"Example commit6"
    checkout poc-pong
    commit id:"Example commit7"
    commit id:"Example commit8"
    checkout poc-tictactoe
    commit id:"Example commit9"
    commit id:"Example commit10"
    checkout main
    merge poc-tictactoe
    checkout zarlasht
    commit id:"Example commit11"
    commit id:"Example commit12"
    checkout final
    commit id:"Example commit13"
    commit id:"Example commit14"
    commit id:"completed"
    checkout main
    merge plan
    merge poc-online_chat
    merge poc-pong
    merge zarlasht
    merge final
    commit id:"Deliverable"
```

</details>

### Product deployment

Deployment differs for each product produced. Please see the `README.md` files
for their respective folders for details on this.
