//SPDX-License-Identifier: Unlicense

pragma solidity >=0.5.0 <0.9.0;

contract EventContract{

    struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
    }


//mapping since we are creating multiple events

mapping(uint => Event) public events;
//no. of events and each key with each event no

mapping(address => mapping(uint => uint)) public tickets;

//
uint public nextId;

function createEvent(string memory name, uint date, uint prize,uint ticketCount) external {
    require(date > block.timestamp,"you can create event for future date");
    require(ticketCount > 0,"You can organize event only if you create more than 0 tickets");

    events[nextId] = Event(msg.sender,name,date,prize,ticketCount,ticketCount);
    nextId++;
}
//epochConveter For timestamp to pass


function buyTicket(uint id, uint quantity) external payable{
    require (events[id].date != 0, "this event does'nt exist");
    require(events[id].date > block.timestamp, "this event is over!!");

    Event storage _event = events[id];

    require(msg.value == (_event.price*quantity),"ether is not enough!!");

    require(_event.ticketRemain >= quantity, "not enough tickets");

    //_event.ticketRemain = _event.ticketRemain - quantity;

    tickets[msg.sender][id] += quantity;
}

function transferTicket (uint id, uint quantity, address to)external{
    require (events[id].date != 0, "this event does'nt exist");
    require(events[id].date > block.timestamp, "this event is over!!");

    require(tickets[msg.sender][id] >= quantity, "you don't have enough tickets");

    tickets[msg.sender][id] -= quantity;

    tickets[to][id] = quantity;

}



}