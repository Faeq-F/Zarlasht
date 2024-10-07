# Final Year Project

Created during the 2024-2025 CS3821 module 'Final Year Project - Full Unit' at Royal Holloway, University of London.

Project Title: A concurrency based game environment

### Repository Structure

Code for different parts of the project, and the different reports produced, are in their respective folders, worked on in their respective branches. See below, an example of the repository structure (excluding feature-branches, etc.), and the file structure of the main branch;

#### Repository structure

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
gitGraph
    commit id:"Initial commit"
    branch plan
    branch poc_online_chat
    branch poc_pong
    branch poc_tictactoe
    branch final_game
    branch interim_report
    checkout main
    commit id:"Update to diary.md"
    commit id:"Added log to diary"
    commit id:"added to diary"
    checkout interim_report
    commit id:"Example commit1"
    commit id:"Example commit2"
    commit id:"Example commit3"
    commit id:"completed submission"
    branch final_report
    checkout final_report
    commit id:"Example commit6"
    commit id:"Example commit7"
    commit id:"Example commit8"
    checkout plan
    commit id:"Example commit11"
    commit id:"Example commit12"
    commit id:"Example commit13"
    checkout poc_online_chat
    commit id:"Example commit15"
    commit id:"Example commit16"
    commit id:"Example commit17"
    commit id:"Example commit18"
    checkout poc_pong
    commit id:"Example commit19"
    commit id:"Example commit20"
    commit id:"Example commit21"
    commit id:"Example commit22"
    checkout poc_tictactoe
    commit id:"Example commit23"
    commit id:"Example commit24"
    commit id:"Example commit25"
    checkout main
    merge poc_tictactoe
    checkout final_game
    commit id:"Example commit26"
    commit id:"Example commit28"
    commit id:"Example commit29"
    commit id:"Example commit30"
    checkout main
    merge plan
    merge poc_online_chat
    merge poc_pong
    merge final_game
    merge final_report
    commit id:"Deliverable"
```
