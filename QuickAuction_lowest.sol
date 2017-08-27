contract AuickAuction {
   struct auction {
      uint lowestBid;
      address lowestBidder;
      address recipient;
      string name;
   }
   mapping(uint => auction) Auctions;
   uint public totalAuctions;
  event Update(string name, uint lowestBid, address lowestBidder, address recipient, uint auctionID);
  event Ended(uint auctionID);
  function startAuction(string name, uint timeLimit) returns (uint auctionID) {
     auctionID = totalAuctions++;
     Auctions[auctionID].recipient = msg.sender;
     Auctions[auctionID].name = name;
    Update(name, Auctions[auctionID].lowestBid, Auctions[auctionID].lowestBidder, Auctions[auctionID].recipient, auctionID);
   }
   function placeBid(uint id, uint value) returns (address lowestBidder) {
      auction a = Auctions[id];
      if (a.lowestBid != 0 && a.lowestBid < value) {
         msg.sender.send(msg.value);
         return a.lowestBidder;
      }
      a.lowestBidder.send(a.lowestBid);
      a.lowestBidder = msg.sender;
      a.lowestBid = value;
      Update(a.name, a.lowestBid, a.lowestBidder, a.recipient, id);  
      return msg.sender;
   }
   function endAuction(uint id) returns (address lowestBidder) {
      auction a = Auctions[id];
      if (msg.sender != a.recipient) {
         msg.sender.send(msg.value);
         return a.recipient;
      }
      a.recipient.send(a.lowestBid);
      a.lowestBid = 0;
      a.lowestBidder =0;
      a.recipient = 0;
      Ended(id);
   }
   function getlowestBid(uint id) constant returns (uint lowestBid) {
      return Auctions[id].lowestBid;
   }
 
   function getAuction(uint id) constant returns (uint lowestBid, address lowestBidder, address recipient, string name) {
      auction a = Auctions[id];
      lowestBid = a.lowestBid;
      lowestBidder = a.lowestBidder;
      recipient = a.recipient;
      name = a.name;
   }
}