// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GPUVerifier {
    address public owner;

    // 私有 mapping 儲存序號哈希與狀態
    mapping(bytes32 => bool) private registeredSerials;

    // 新增序號時觸發事件，帶出序號字串
    event SerialRegistered(string serial);

    // 只允許擁有者呼叫的修飾子
    modifier onlyOwner() {
        require(msg.sender == owner, unicode"只有擁有者可以執行");
        _;
    }

    // 部署合約時設定擁有者
    constructor() {
        owner = msg.sender;
    }

    // 註冊序號
    function registerSerial(bytes32 serialHash) external onlyOwner {
        require(!registeredSerials[serialHash], unicode"序號已註冊");
        registeredSerials[serialHash] = true;
        emit SerialRegistered(bytes32ToString(serialHash));
    }

    // 查詢序號是否有效
    function isSerialValid(bytes32 serialHash) external view returns (bool) {
        return registeredSerials[serialHash];
    }

    // bytes32 轉 string（簡單示範用）
    function bytes32ToString(bytes32 _bytes32) internal pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
}
