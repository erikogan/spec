describe :kernel_sprintf, shared: true do
  def format(*args)
    @method.call(*args)
  end

  describe "integer formats" do
    it "converts argument into Integer with to_int" do
      obj = mock("integer")
      obj.should_receive(:to_int).and_return(10)
      format("%b", obj).should == "1010"
    end

    it "converts argument into Integer with to_i" do
      obj = mock("integer")
      obj.should_receive(:to_i).and_return(10)
      format("%b", obj).should == "1010"
    end

    it "uses to_int first" do
      obj = Object.new
      def obj.to_i;   0 end
      def obj.to_int; 1 end

      format("%b", obj).should == "1"
    end

    it "supports as many string formats as Kernel#Integer does" do
      format("%d", "0b1010").should == "10"
      format("%d", "112").should == "112"
      format("%d", "0127").should == "87"
      format("%d", "0xc4").should == "196"
    end

    it "raises TypeError exception if cannot convert to Integer" do
      -> () {
        format("%b", Object.new)
      }.should raise_error(TypeError)
    end

    describe "b" do
      it "converts argument as a binary number" do
        format("%b", 10).should == "1010"
      end

      it "displays negative number as a two's complement prefixed with '..1'" do
        format("%b", -10).should == "..1" + "0110"
      end

      it "collapse negative number representation if it equals 1" do
        format("%b", -1).should_not == "..11"
        format("%b", -1).should == "..1"
      end
    end

    describe "B" do
      it "converts argument as a binary number" do
        format("%B", 10).should == "1010"
      end

      it "displays negative number as a two's complement prefixed with '..1'" do
        format("%B", -10).should == "..1" + "0110"
      end

      it "collapse negative number representation if it equals 1" do
        format("%B", -1).should_not == "..11"
        format("%B", -1).should == "..1"
      end
    end

    describe "d" do
      it "converts argument as a decimal number" do
        format("%d", 112).should == "112"
        format("%d", -112).should == "-112"
      end
    end

    describe "i" do
      it "converts argument as a decimal number" do
        format("%i", 112).should == "112"
        format("%i", -112).should == "-112"
      end
    end

    describe "o" do
      it "converts argument as an octal number" do
        format("%o", 87).should == "127"
      end

      it "displays negative number as a two's complement prefixed with '..7'" do
        format("%o", -87).should == "..7" + "651"
      end

      it "collapse negative number representation if it equals 7" do
        format("%o", -1).should_not == "..77"
        format("%o", -1).should == "..7"
      end
    end

    describe "u" do
      it "converts argument as a decimal number" do
        format("%u", 112).should == "112"
        format("%u", -112).should == "-112"
      end
    end

    describe "x" do
      it "converts argument as a hexadecimal number" do
        format("%x", 196).should == "c4"
      end

      it "displays negative number as a two's complement prefixed with '..f'" do
        format("%x", -196).should == "..f" + "3c"
      end

      it "collapse negative number representation if it equals f" do
        format("%x", -1).should_not == "..ff"
        format("%x", -1).should == "..f"
      end
    end

    describe "X" do
      it "converts argument as a hexadecimal number with uppercase letters" do
        format("%X", 196).should == "C4"
      end

      it "displays negative number as a two's complement prefixed with '..f'" do
        format("%X", -196).should == "..F" + "3C"
      end

      it "collapse negative number representation if it equals F" do
        format("%X", -1).should_not == "..FF"
        format("%X", -1).should == "..F"
      end
    end
  end

  describe "float formats" do
    it "converts argument into Float" do
      obj = mock("float")
      obj.should_receive(:to_f).and_return(9.6)
      format("%f", obj).should == "9.600000"
    end

    it "raises TypeError exception if cannot convert to Float" do
      -> () {
        format("%f", Object.new)
      }.should raise_error(TypeError)
    end

    describe "e" do
      it "convets argument into exponential notation [-]d.dddddde[+-]dd" do
        format("%e", 109.52).should == "1.095200e+02"
        format("%e", -109.52).should == "-1.095200e+02"
        format("%e", 0.10952).should == "1.095200e-01"
        format("%e", -0.10952).should == "-1.095200e-01"
      end

      it "cuts excessive digits" do
        format("%e", 1.123456789).should == "1.123457e+00"
      end

      it "rounds the last significant digit to the closest one" do
        format("%e", 1.555555555).should == "1.555556e+00"
        format("%e", -1.555555555).should == "-1.555556e+00"
        format("%e", 1.444444444).should == "1.444444e+00"
      end

      it "displays Float::INFINITY as Inf" do
        format("%e", Float::INFINITY).should == "Inf"
        format("%e", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%e", Float::NAN).should == "NaN"
        format("%e", -Float::NAN).should == "NaN"
      end
    end

    describe "E" do
      it "convets floating point argument into exponential notation [-]d.dddddde[+-]dd" do
        format("%E", 109.52).should == "1.095200E+02"
        format("%E", -109.52).should == "-1.095200E+02"
        format("%E", 0.10952).should == "1.095200E-01"
        format("%E", -0.10952).should == "-1.095200E-01"
      end

      it "cuts excessive digits" do
        format("%E", 1.123456789).should == "1.123457E+00"
      end

      it "rounds the last significant digit to the closest one" do
        format("%E", 1.555555555).should == "1.555556E+00"
        format("%E", -1.555555555).should == "-1.555556E+00"
        format("%E", 1.444444444).should == "1.444444E+00"
      end

      it "displays Float::INFINITY as Inf" do
        format("%E", Float::INFINITY).should == "Inf"
        format("%E", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%E", Float::NAN).should == "NaN"
        format("%E", -Float::NAN).should == "NaN"
      end
    end

    describe "f" do
      it "converts floating point argument as [-]ddd.dddddd" do
        format("%f", 10.952).should == "10.952000"
        format("%f", -10.952).should == "-10.952000"
      end

      it "cuts excessive digits" do
        format("%f", 1.123456789).should == "1.123457"
      end

      it "rounds the last significant digit to the closest one" do
        format("%f", 1.555555555).should == "1.555556"
        format("%f", -1.555555555).should == "-1.555556"
        format("%f", 1.444444444).should == "1.444444"
      end

      it "displays Float::INFINITY as Inf" do
        format("%f", Float::INFINITY).should == "Inf"
        format("%f", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%f", Float::NAN).should == "NaN"
        format("%f", -Float::NAN).should == "NaN"
      end
    end

    describe "g" do
      context "the exponenta is less than -4" do
        it "converts a floating point number using exponential form" do
          format("%g", 0.0000123456).should == "1.23456e-05"
          format("%g", -0.0000123456).should == "-1.23456e-05"

          format("%g", 0.000000000123456).should == "1.23456e-10"
          format("%g", -0.000000000123456).should == "-1.23456e-10"
        end
      end

      context "the exponenta is greater than or equal to the precision (6 by default)" do
        it "converts a floating point number using exponential form" do
          format("%g", 1234567).should == "1.23457e+06"
          format("%g", 1234567890123).should == "1.23457e+12"
          format("%g", -1234567).should == "-1.23457e+06"
        end
      end

      context "otherwise" do
        it "converts a floating point number in dd.dddd form" do
          format("%g", 0.0001).should == "0.0001"
          format("%g", -0.0001).should == "-0.0001"
          format("%g", 123456).should == "123456"
          format("%g", -123456).should == "-123456"
        end

        it "cuts excessive digits in fractional part" do
          format("%g", 12.12341111).should == "12.1234"
          format("%g", -12.12341111).should == "-12.1234"
        end

        it "rounds the last significant digit to the closest one in fractional part" do
          format("%g", 1.555555555).should == "1.55556"
          format("%g", -1.555555555).should == "-1.55556"
          format("%g", 1.444444444).should == "1.44444"
        end

        # strange behavior
        it "cuts fraction part to have only 6 digits at all" do
          format("%g", 1.1234567).should == "1.12346"
          format("%g", 12.1234567).should == "12.1235"
          format("%g", 123.1234567).should == "123.123"
          format("%g", 1234.1234567).should == "1234.12"
        end
      end

      it "displays Float::INFINITY as Inf" do
        format("%g", Float::INFINITY).should == "Inf"
        format("%g", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%g", Float::NAN).should == "NaN"
        format("%g", -Float::NAN).should == "NaN"
      end
    end

    describe "G" do
      context "the exponenta is less than -4" do
        it "converts a floating point number using exponential form and use an uppercase E" do
          format("%G", 0.0000123456).should == "1.23456E-05"
          format("%G", -0.0000123456).should == "-1.23456E-05"

          format("%G", 0.000000000123456).should == "1.23456E-10"
          format("%G", -0.000000000123456).should == "-1.23456E-10"
        end
      end

      context "the exponenta is greater than or equal to the precision (6 by default)" do
        it "converts a floating point number using exponential form" do
          format("%G", 1234567).should == "1.23457E+06"
          format("%G", 1234567890123).should == "1.23457E+12"
          format("%G", -1234567).should == "-1.23457E+06"
        end
      end

      context "otherwise" do
        it "converts a floating point number in dd.dddd form" do
          format("%G", 0.0001).should == "0.0001"
          format("%G", -0.0001).should == "-0.0001"
          format("%G", 123456).should == "123456"
          format("%G", -123456).should == "-123456"
        end

        it "cuts excessive digits in fractional part" do
          format("%G", 12.12341111).should == "12.1234"
          format("%G", -12.12341111).should == "-12.1234"
        end

        it "rounds the last significant digit to the closest one in fractional part" do
          format("%G", 1.555555555).should == "1.55556"
          format("%G", -1.555555555).should == "-1.55556"
          format("%G", 1.444444444).should == "1.44444"
        end

        # strange behavior
        it "cuts fraction part to have only 6 digits at all" do
          format("%G", 1.1234567).should == "1.12346"
          format("%G", 12.1234567).should == "12.1235"
          format("%G", 123.1234567).should == "123.123"
          format("%G", 1234.1234567).should == "1234.12"
        end
      end

      it "displays Float::INFINITY as Inf" do
        format("%G", Float::INFINITY).should == "Inf"
        format("%G", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%G", Float::NAN).should == "NaN"
        format("%G", -Float::NAN).should == "NaN"
      end
    end

    describe "a" do
      # strange behavior
      # from docs - Convert floating point argument as [-]0xh.hhhhp[+-]dd
      # * p+7 => p+07 - two digits for exponenta
      # * fraction part should be 4 digits long by default
      it "converts floating point argument as [-]0xh.hhhhp[+-]dd" do
        format("%a", 196).should == "0x1.88p+7"
        format("%a", -196).should == "-0x1.88p+7"
        format("%a", 196.1).should == "0x1.8833333333333p+7"
        format("%a", 0.01).should == "0x1.47ae147ae147bp-7"
        format("%a", -0.01).should == "-0x1.47ae147ae147bp-7"
      end

      it "displays Float::INFINITY as Inf" do
        format("%a", Float::INFINITY).should == "Inf"
        format("%a", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%a", Float::NAN).should == "NaN"
        format("%a", -Float::NAN).should == "NaN"
      end
    end

    describe "A" do
      it "converts floating point argument as [-]0xh.hhhhp[+-]dd and use uppercase X and P" do
        format("%A", 196).should == "0X1.88P+7"
        format("%A", -196).should == "-0X1.88P+7"
        format("%A", 196.1).should == "0X1.8833333333333P+7"
        format("%A", 0.01).should == "0X1.47AE147AE147BP-7"
        format("%A", -0.01).should == "-0X1.47AE147AE147BP-7"
      end

      it "displays Float::INFINITY as Inf" do
        format("%A", Float::INFINITY).should == "Inf"
        format("%A", -Float::INFINITY).should == "-Inf"
      end

      it "displays Float::NAN as NaN" do
        format("%A", Float::NAN).should == "NaN"
        format("%A", -Float::NAN).should == "NaN"
      end
    end
  end

  describe "other formats" do
    describe "c" do
      it "displays character if argument is a numeric code of character" do
        format("%c", 97).should == "a"
      end

      it "displays character if argument is a single character string" do
        format("%c", "a").should == "a"
      end

      it "raises ArgumentError if argument is a string of several characters" do
        -> () {
          format("%c", "abc")
        }.should raise_error(ArgumentError)
      end

      it "supports Unicode characters" do
        format("%c", 1286).should == "Ԇ"
        format("%c", "ش").should == "ش"
      end
    end

    describe "p" do
      it "displays argument.inspect value" do
        obj = mock("object")
        obj.should_receive(:inspect).and_return("<inspect-result>")
        format("%p", obj).should == "<inspect-result>"
      end
    end

    describe "s" do
      it "substitute argument passes as a string" do
        format("%s", "abc").should == "abc"
      end

      it "converts argument to string with to_s" do
        obj = mock("string")
        obj.should_receive(:to_s).and_return("abc")
        format("%s", obj).should == "abc"
      end

      # strange behavior
      # expected any core/std lib uses to_int/to_str/to_ary/to_hash for argument
      it "does not try to convert with to_str" do
        obj = BasicObject.new
        def obj.to_str
          "abc"
        end

        -> () {
          format("%s", obj)
        }.should raise_error(NoMethodError)
      end
    end

    describe "%" do
      it "displays percent sign itself" do
        format("%").should == "%"
      end

      it "is escaped by %" do
        format("%%").should == "%"
        format("%%d", 10).should == "%d"
      end
    end
  end
end
