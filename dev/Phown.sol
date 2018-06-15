pragma solidity ^0.4.16;

contract Phown {
    
    struct Data {
        uint imei; 
        bool marked;
        uint ownershipCount;
    }

    mapping (address => mapping (uint => Data)) public items;
    mapping (uint => address) reverseItems;
    
    event Register(address indexed user, uint imei);
    event Mark(uint imei);
    event Unmark(uint imei);
    event Transfer(uint imei);

    function register(uint imei) public {
        require(items[msg.sender][imei].imei == 0);
        require(reverseItems[imei] == 0);
        
        items[msg.sender][imei] = Data({imei: imei, marked: false, ownershipCount: 0});
        reverseItems[imei] = msg.sender;
        
        emit Register(msg.sender, imei);
    }
    
    function transfer(uint imei, address addr) public {
        require(items[msg.sender][imei].imei == imei);
        require(items[msg.sender][imei].marked == false);
        
        items[addr][imei] = items[msg.sender][imei];
        items[addr][imei].ownershipCount += 1;
        items[msg.sender][imei] = Data({imei: 0, marked: false, ownershipCount: 0});
        reverseItems[imei] = addr;
        
        emit Transfer(imei);
    }

    function mark(uint imei) public {
        require(items[msg.sender][imei].imei == imei);
        require(items[msg.sender][imei].marked == false);
        items[msg.sender][imei].marked = true;
        
        emit Mark(imei);
    }

    function unmark(uint imei) public {
        require(items[msg.sender][imei].imei == imei);
        require(items[msg.sender][imei].marked == true);
        items[msg.sender][imei].marked = false;
        
        emit Unmark(imei);
    }

}