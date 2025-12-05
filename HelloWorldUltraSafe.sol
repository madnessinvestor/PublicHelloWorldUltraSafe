// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title PublicHelloWorldUltraSafe
/// @notice A fully secure public on-chain message board for posting short "hello" messages.
/// @dev Does not accept ETH, does not move tokens, and performs no external calls.
contract PublicHelloWorldUltraSafe {

    /// @notice Struct that represents a single hello message.
    /// @param author The address that sent the message.
    /// @param timestamp The block timestamp when the message was created.
    /// @param message The text content of the hello message.
    struct Hello {
        address author;
        uint256 timestamp;
        string message;
    }

    /// @notice Array containing all hello messages.
    Hello[] private hellos;

    /// @notice Emitted when a new hello message is posted.
    /// @param author The address that posted the message.
    /// @param index The index of the message inside the array.
    /// @param message The content of the posted message.
    event HelloSaid(address indexed author, uint256 indexed index, string message);

    /// @notice This contract does not accept ETH under any circumstances.
    receive() external payable {
        revert("This contract does not accept ETH");
    }

    /// @notice Fallback function also rejects ETH or unknown function calls.
    fallback() external payable {
        revert("Function does not exist or ETH sending is not allowed");
    }

    /// @notice Allows any user to post a hello message.
    /// @dev Messages are limited to 80 characters and total messages to 10,000 entries.
    /// @param _message The message text to be posted.
    function sayHello(string calldata _message) external {
        uint256 len = bytes(_message).length;

        require(len > 0, "Empty message not allowed");
        require(len <= 80, "Message must be 80 characters or less");

        require(hellos.length < 10_000, "Message limit reached");

        hellos.push(
            Hello({
                author: msg.sender,
                timestamp: block.timestamp,
                message: _message
            })
        );

        emit HelloSaid(msg.sender, hellos.length - 1, _message);
    }

    /// @notice Returns the total number of hello messages posted.
    /// @return The number of hello messages.
    function getHelloCount() external view returns (uint256) {
        return hellos.length;
    }

    /// @notice Returns a specific hello message by index.
    /// @param index The index of the message in the array.
    /// @return author The address that posted the message.
    /// @return timestamp The timestamp when the message was posted.
    /// @return message The message text.
    function getHello(uint256 index)
        external
        view
        returns (address author, uint256 timestamp, string memory message)
    {
        require(index < hellos.length, "Invalid index");

        Hello storage h = hellos[index];
        return (h.author, h.timestamp, h.message);
    }
}
