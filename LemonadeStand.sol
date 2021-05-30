
pragma solidity ^0.4.24;

contract LemonadeStand {
    
    enum State { ForSale, Sold }
    
    address owner;
    uint skuCount;
    
    struct Item {
        string name;
        uint sku;
        uint price;
        State state;
        address seller;
        address buyer;
    }
    
    mapping(uint => Item) items;
    
    event ForSale(uint skuCount);
    event Sold(uint sku);
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier verifyCaller(address _address) {
        require(msg.sender == _address);
        _;
    }
    
    modifier paidEnough(uint _price) {
        require(msg.value >= _price);
        _;
    }
    
    modifier forSale(uint _sku) {
        require(items[_sku].state == State.ForSale);
        _;
    }
    
    modifier sold(uint _sku) {
        require(items[_sku].state == State.Sold);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
        skuCount = 0;
    }
    
    function addItem(string _name, uint _price) onlyOwner public {
        skuCount = skuCount + 1;
        emit ForSale(skuCount);
        items[skuCount] = Item({name: _name, sku: skuCount, price: _price, state: State.ForSale, buyer: 0, seller: msg.sender});
    }
    
    function buyItem(uint _sku) forSale(_sku) paidEnough(items[_sku].price) public payable {
        address buyer = msg.sender;
        uint price = items[_sku].price;
        items[_sku].buyer = buyer;
        items[_sku].state = State.Sold;
        items[_sku].seller.transfer(price);
        emit Sold(_sku);
    }
    
    function fetchItem(uint _sku) public view returns (string name, uint sku, uint price, string stateIs, address seller, address buyer) {
        uint state;
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        state = uint(items[sku].state);
        if(state == 0) {
            stateIs = "For Sale";
        }
        if(state == 1) {
            stateIs = "Sold";
        }
        seller = items[sku].seller;
        buyer = items[sku].buyer;
    }
    
    
}