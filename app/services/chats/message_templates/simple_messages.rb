module Chats
  module MessageTemplates
    module SimpleMessages
      def searching_template
        {text: "Searching..."}
      end

      def processing_template
        {text: "Processing..."}
      end

      def enter_book_name_template
        {text: "Please enter the book's name"}
      end

      def enter_book_id_template
        {text: "Please enter the GoodRead's ID for the book"}
      end

      def recommend_buy_template
        {text: "Recommended to buy"}
      end

      def not_recommend_buy_template
        {text: "Not recommended to buy"}
      end

      def not_found_template
        {text: "Not found, please try again."}
      end

      def error_template
        {text: "Something went wrong, please try again."}
      end
    end
  end
end
