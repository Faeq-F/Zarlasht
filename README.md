# Final Year Project

Created during the 2024-2025 CS3821 module 'Final Year Project - Full Unit' at Royal Holloway, University of London.

Project Title: A concurrency based game environment

### Repository Structure

Code for different parts of the project, and the different reports produced, are in their respective folders, worked on in their respective branches.<br>
See below, an example of the repository structure (excluding feature-branches, etc.), and the file structure of the main branch;

<details><summary>Example of repository file structure</summary>
<!-- prettier-ignore-start -->
root<br>
│<br>
├── plan_&_reports<br>
│   ├── fyp_plan.tex<br>
│   ├── plan_refs.bib<br>
│   │<br>
│   ├── interim_report.tex<br>
│   ├── interim_refs.bib<br>
│   │<br>
│   ├── final_report.tex<br>
│   ├── final_refs.bib<br>
│   │<br>
│   └── styles.cls<br>
│<br>
├── proof_of_concepts<br>
│   ├── online_chat<br>
│   │   └── ... (code)<br>
│   │<br>
│   ├── tic-tac-toe_(board_game)<br>
│   │   └── ... (code)<br>
│   │<br>
│   └── pong_(game)<br>
│       └── ... (code)<br>
│<br>
├── zarlasht_(final_game)<br>
│   └── ... (code)<br>
│<br>
├── README.md<br>
└── DIARY.md<br>
<!-- prettier-ignore-end -->
</details>

<details><summary>Example git graph for a single deliverable's history</summary>

Everything is worked on in their respective branches. All of these branches will then be merged to main to create a deliverable.

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
    branch poc_online_chat
    branch poc_pong
    branch poc_tictactoe
    branch final_game
    branch interim_report
    checkout main
    commit id:"Update to diary.md"
    checkout plan
    commit id:"Example commit1"
    commit id:"Example commit2"
    checkout main
    commit id:"Added log to diary"
    commit id:"throughout the project"
    checkout interim_report
    commit id:"Example commit3"
    commit id:"Example commit4"
    commit id:"completed submission"
    branch final_report
    checkout poc_online_chat
    commit id:"Example commit5"
    commit id:"Example commit6"
    checkout poc_pong
    commit id:"Example commit7"
    commit id:"Example commit8"
    checkout poc_tictactoe
    commit id:"Example commit9"
    commit id:"Example commit10"
    checkout main
    merge poc_tictactoe
    checkout final_game
    commit id:"Example commit11"
    commit id:"Example commit12"
    checkout final_report
    commit id:"Example commit13"
    commit id:"Example commit14"
    commit id:"completed"
    checkout main
    merge plan
    merge poc_online_chat
    merge poc_pong
    merge final_game
    merge final_report
    commit id:"Deliverable"
```

</details>
