require 'minitest/autorun'

describe Array do
  # Array's public methods
  describe "Class Methods" do
    describe ".[]" do
      it "returns an array populated with the given objects" do
        Array.[](0, 'a', []).must_equal [0, 'a', []]
        Array[1, '1', {}].must_equal [1, '1', {}]
        [1, 'a', 0].must_equal [1, 'a', 0]
      end
    end

    describe ".new" do
      it "instantiates an Array object with specified size" do
        Array.new(1).must_equal [nil]
      end

      it "creates an Array with specified size and object" do
        Array.new(3, 1).must_equal [1, 1, 1]
        Array.new(3, Array.new(3)).must_equal [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        # each value in the array points to the same object
        array_with_hashes = Array.new(2, Hash.new)
        array_with_hashes[0]['test'] = 'same'
        array_with_hashes.must_equal [{'test' => 'same'}, {'test' => 'same'}]
      end

      it "creates an Array with specified size and multiple copies of an object" do
        array = Array.new(2) { Hash.new }
        array[0]['test'] = 'not the same'
        array.must_equal [{'test' => 'not the same'}, {}]
      end

      it "returns a copy of provided Array" do
        first_array = ["Me", "You"]
        second_array = Array.new(first_array)
        second_array.must_equal first_array
        second_array.object_id.wont_equal first_array.object_id
      end

      it "returns an array with its index as its values" do
        Array.new(3) {|index| index}.must_equal [0, 1, 2]
        Array.new(3) {|index| index * 2}.must_equal [0, 2, 4]
      end
    end

    describe ".try_convert" do
      # can be used to check if argument is an array
      it "returns the array when argument is an array" do
        Array.try_convert([1]).must_equal [1]
      end

      it "returns nil when the argument is not an array" do
        Array.try_convert(1).must_equal nil
        Array.try_convert('1').must_equal nil
        Array.try_convert({}).must_equal nil
      end
    end  
  end
  
  describe "Instance Methods" do
    describe "#&" do
      # opposite of #uniq
      it "returns an array of values that are common in 2 arrays" do
        array = [0, 0, 5, 9, 12]
        array2 = [0, 13, 11, 5]
        (array & array2).must_equal [0,5]
      end
    end

    describe "#*" do
      describe "when argument provided is a String" do
        it "returns a string joined by the provided string" do
          ([1, 2, 3] * ",").must_equal "1,2,3"
          # equivalent to ary.join(",")
        end
      end

      describe "when argument provided is an Integer" do
        it "returns a new array of concatenated 'int' copies of self" do
          ([1, 2, 3] * 3).must_equal [1, 2, 3, 1, 2, 3, 1, 2, 3] 
        end
      end
    end

    describe "#-" do
      it "returns an array minus any values that exist in the argument array" do
        ([1, 2, 3, 4, 5] - [1, 4, 5]).must_equal [2, 3]
      end
    end

    describe "#<<" do
      it "returns the array with the given object pushed to the end of the array" do
        ([1, 2, 3] << "c").must_equal [1, 2, 3, "c"]
      end
    end

    describe "#==" do
      it "returns true when an array has the same elements with another array" do
        ([1, 2, 3] == [1, 2, 3]).must_equal true
      end

      it "returns false when an array does not have the same elements with another array" do
        ([1, 2, 3] == [1, 2, 3, 4]).must_equal false
        ([1, 2, 3] == [1, 2, 4]).must_equal false
      end
    end

    describe "#[]" do
      before do
        @ary = [1, 2, 3]
      end

      it "returns an object found in that array's index when one integer argument is provided" do
        @ary[0].must_equal 1
        @ary[1].must_equal 2
        @ary[2].must_equal 3
      end

      it "returns nil if index provided is out of range" do
        @ary[5].must_equal nil
      end

      it "returns an array when 2 integer arguments are provided" do
        # ary[start, length] => new_ary or nil
        @ary[1, 2].must_equal [2, 3]
      end

      it "returns nil when starting index is out of range" do
        @ary[4, 2].must_equal nil
      end

      it "returns an empty array when starting index is at the end of the array" do
        @ary[3, 2].must_equal []
      end

      it "returns an array when a range argument is provided" do
        @ary[0..2].must_equal [1, 2, 3]
        @ary[0...2].must_equal [1, 2]
        @ary[-2..2].must_equal [2, 3]
      end

      it "returns nil when starting index of the range is out of range" do
        @ary[4..5].must_equal nil
      end

      it "returns an empty array when starting index of the range is at the end of the array" do
        @ary[3..5].must_equal []
      end
    end

    describe "#[]=" do
      before do
        @ary = [1, 2, 3]
      end

      it "sets the element at the provided index in the array" do
        @ary[3] = 4
        @ary.must_equal [1, 2, 3, 4]
      end

      it "sets the element at the specified range" do
        @ary[0, 2] = 5
        @ary.must_equal [5, 3]
        @ary[0, 2] = [1, 2, 3, 4, 5]
        @ary.must_equal [1, 2, 3, 4, 5]
        @ary[1..3] = [1, 2, 3]
        @ary.must_equal [1, 1, 2, 3, 5]
        @ary[-1..0] = "A"
        @ary.must_equal [1, 1, 2, 3, "A", 5]
        @ary[-1, 1] = "B"
        @ary.must_equal [1, 1, 2, 3, "A", "B"]
      end
    end
  end 
end
