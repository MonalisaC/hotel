- What classes does each implementation include? Are the lists the same?
  - Yes , both include same classes. They are CartEntry, ShoppingCart and Order.

- Write down a sentence to describe each class.
  - CartEntry- It represents a shopping cart item entry.
  - ShoppingCart- It contains all the entries.
  - Order- It represent initialization of new shopping cart instance.

- How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
  - Order has a ShoppingCart.
  - ShoppingCart has a list of CartEntry

- What data does each class store? How (if at all) does this differ between the two implementations?
  - CartEntry has unit_price and quantity, ShoppingCart has entries and Order has cart and total_price. In implementation A only the class Order has the responsibility of calculating total_cost.In implementation B CartEntry calculates price, ShoppingCart return sum and Order return total_price.

- What methods does each class have? How (if at all) does this differ between the two implementations?
  - CartEntry, ShoppingCart, and Order has initialize and Order has total_price method in both implementations. In implementation B CartEntry and ShoppingCart both have their price method.

- Consider the Order#total_price method. In each implementation:
- Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
  - In implementation A it's retained in Order and in implementation B it's delegated.
- Does total_price directly manipulate the instance variables of other classes?
  - NO.

- If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
  - In implementation A Order#total_price has to be updated to add a if condition when calculating the sum. In implementation B the CartEntry price method can be updated. Implementation B is easier to modify and easier to supoort different use cases.

- Which implementation better adheres to the single responsibility principle?
  - Implementation B

- Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
  - Implementation B
