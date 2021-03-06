require "test_helper"

describe RentalsController do
  describe "checkout" do
    let(:rental_data) {
      {
        movie_id: movies(:one).id,
        customer_id: customers(:two).id,
      }
    }

    it "can create a new rental provided valid data" do
      expect {
        post checkout_path, params: rental_data
      }.must_change "Rental.count", +1

      new_rental = Rental.last

      must_respond_with :success

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
    end

    it "won't create new rental provided invalid customer" do
      rental_data["customer_id"] = -7

      expect {
        post checkout_path, params: rental_data
      }.wont_change "Rental.count"

      must_respond_with :bad_request
    end

    it "won't create new rental provided invalid movie" do
      rental_data["movie_id"] = -7

      expect {
        post checkout_path, params: rental_data
      }.wont_change "Rental.count"

      must_respond_with :bad_request
    end
  end

  describe "checkin" do
    it "performs checkin provided valid data" do
      movie = movies(:one)
      customer = customers(:one)
      expect {
        post checkin_path, params: {customer_id: customer.id, movie_id: movie.id}
      }.wont_change "Rental.count"

      must_respond_with :success

      body = JSON.parse(response.body)
      expect(body).must_be_kind_of Hash
      expect(body).must_include "status"
    end

    it "does not checkin provided invalid data" do
      movie = movies(:one)
      expect {
        post checkin_path, params: {customer_id: -7, movie_id: movie.id}
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end

    it "does not checkin if missing data" do
      movie = movies(:one)
      expect {
        post checkin_path, params: {movie_id: movie.id}
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end
  end
end
