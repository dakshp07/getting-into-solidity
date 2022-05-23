pragma solidity >=0.8.4;

contract ToDoList{
    struct ToDo{
        string desc;
        bool comp;
    }
    ToDo[] public todos;
    function set(string calldata _text) external {
        todos.push(ToDo({desc: _text, comp: false}));
    }
    function update(uint ind, string calldata _text) external{
        todos[ind].desc=_text;
    }
    function get(uint ind) public view returns(string memory, bool){
        ToDo memory _todos=todos[ind];
        return (_todos.desc, _todos.comp);
    }
    function toggle(uint ind) external{
        todos[ind].comp=!todos[ind].comp;
    }
}