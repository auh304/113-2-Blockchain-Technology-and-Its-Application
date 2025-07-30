// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // 指定使用 Solidity 編譯器版本為 0.8.0 或以上

// 智慧合約名稱為 IoTCabinet（用於儲存 IoT 事件資料）
contract IoTCabinet {
    // 定義合約擁有者
    address public owner;

    // 定義一個 Event 結構，記錄事件的詳細資訊
    struct Event {
        uint256 timestamp;     // 事件被紀錄的時間（Unix 時間戳）
        string message;        // 事件的文字訊息（如「Cabinet opened」）
        bool isConfirmed;      // 是否已確認該事件
        uint256 confirmedAt;   // 被確認的時間（Unix 時間戳）
    }

    // 宣告一個動態陣列，用來儲存所有事件
    Event[] public events;

    // 建構子，在部署時設定合約擁有者
    constructor() {
        owner = msg.sender; // 部署者即為擁有者
    }

    // 修飾器：僅允許合約擁有者呼叫
    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    // 新增一筆事件的函式，供外部呼叫（如 IoT 裝置）
    function recordEvent(string memory _message) public {
        // 將新的事件推入陣列中，初始化時為未確認狀態
        events.push(Event({
            timestamp: block.timestamp, // 使用區塊鏈目前時間記錄事件發生時間
            message: _message,          // 儲存傳入的事件訊息
            isConfirmed: false,         // 預設為未確認
            confirmedAt: 0              // 確認時間設為 0（尚未確認）
        }));
    }

    // 確認一筆事件的函式，僅允許合約擁有者操作
    function confirmEvent(uint256 _index) public onlyOwner {
        // 檢查索引是否有效
        require(_index < events.length, "Invalid event index");
        // 防止重複確認
        require(!events[_index].isConfirmed, "Already confirmed");

        // 設定該事件為已確認，並紀錄確認時間
        events[_index].isConfirmed = true;
        events[_index].confirmedAt = block.timestamp;
    }

    // 取得所有事件的函式，回傳整個事件陣列
    function getAllEvents() public view returns (Event[] memory) {
        return events;
    }
}
