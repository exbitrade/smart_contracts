pragma solidity ^0.4.16;

// PhownDelegated is an extended version of Phown
// for users who are not able to directly call below
// functions due to lack of ether in their address.
// This contract's functions can only be called by its creator.

contract PhownDelegated {
    
    struct Data {
        uint imei; 
        bool marked;
        uint ownershipCount;
    }

    mapping (address => mapping (uint => Data)) public items;
    mapping (uint => address) reverseItems;
    
    address creator;
    
    event Register(address indexed user, uint imei);
    event Mark(uint imei);
    event Unmark(uint imei);
    event Transfer(uint imei);
    
    constructor() public {
        creator = msg.sender;
    }

    function register(address addr, uint imei) public onlyCreator {
        require(items[addr][imei].imei == 0);
        require(reverseItems[imei] == 0);
        
        items[addr][imei] = Data({imei: imei, marked: false, ownershipCount: 0});
        reverseItems[imei] = msg.sender;
        
        emit Register(addr, imei);
    }
    
    function transfer(uint imei, address owner_addr, address new_addr) public onlyCreator {
        require(items[owner_addr][imei].imei == imei);
        require(items[owner_addr][imei].marked == false);
        
        items[new_addr][imei] = items[owner_addr][imei];
        items[new_addr][imei].ownershipCount += 1;
        items[owner_addr][imei] = Data({imei: 0, marked: false, ownershipCount: 0});
        reverseItems[imei] = new_addr;
        
        emit Transfer(imei);
    }

    function mark(address addr, uint imei) public onlyCreator {
        require(items[addr][imei].imei == imei);
        require(items[addr][imei].marked == false);
        items[addr][imei].marked = true;
        emit Mark(imei);
    }

    function unmark(address addr, uint imei) public onlyCreator {
        require(items[addr][imei].imei == imei);
        require(items[addr][imei].marked == true);
        items[addr][imei].marked = false;
        emit Unmark(imei);
    }
    
    modifier onlyCreator() {
        require(msg.sender == creator);
        _;
    }

}


