require "test_helper"

describe CustomersController do
  describe "index" do
    it "is a real working route" do
      get customers_path
      must_respond_with :success
    end
  end

  describe "routes" do
    it "is a real working route and returns JSON" do
      # Act
      get customers_path
    
      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
    end

    it "returns an Array" do
      # Act
      get customers_path
    
      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)
    
      # Assert
      expect(body).must_be_kind_of Array
    end

    it "returns all of the customers" do
      # Act
      get customers_path
    
      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)
    
      # Assert
      expect(body.length).must_equal Customer.count
    end

    it "returns customers with exactly the required fields" do
      keys = %w(id movies_checked_out_count name phone postal_code registered_at)
    
      # Act
      get customers_path
    
      # Convert the JSON response into a Hash
      body = JSON.parse(response.body)
    
      # Assert that each
      body.each do |customer|
        expect(customer.keys.sort).must_equal keys
        expect(customer.keys.length).must_equal keys.length
      end
    end

    it "returns an empty array if there are no customers" do
      Rental.destroy_all
      Customer.destroy_all
      get customers_path
      expect(Customer.count).must_equal 0
    end
  end
end
