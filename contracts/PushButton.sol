pragma solidity ^0.4.13;

contract PushButton {
    uint public startBlock; // 記錄合約起始block
    uint public interval = 108 * 60 / 4; // 108分鐘 (Kovan testnet)
    uint public nextTimeoutBlock; // 下一次timeout block
    uint public totalPush; // 總共按了幾次
    string public title; // 依據totalPush可獲得不同title, just for fun 

    event ButtonPushed(address indexed _address, uint _totalPush, uint _nextTimeoutBlock);

    modifier isTimeout() {
        require( getBlock() <= nextTimeoutBlock );
        _;
    }

    function PushButton() {
        startBlock = block.number; // 紀錄合約部署當下的block number
        nextTimeoutBlock = startBlock + interval; // 計算timeout
        totalPush = 0;
    }

    function push() isTimeout() returns (bool) {
        totalPush += 1; // total push +1
        nextTimeoutBlock = getBlock() + interval; // 更新nextTimeoutBlock
        checkTitle(); // 更新title, just for fun
        ButtonPushed(msg.sender, totalPush, nextTimeoutBlock); //發event
        return true;
    }


    function getBlock() constant returns (uint) {
        return block.number;
    }

    function checkTitle() internal {
        if (totalPush < 10) {
            title = "嫩雞";
        } else if (totalPush < 20) {
            title = "初心者";
        } else if (totalPush < 100) {
            title = "有點猛 ";
        } else {
            title = "加藤鷹4in1";
        }
    }
}