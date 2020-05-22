module Chats
  module MessageTemplates
    module BookSelections
      def select_books_template(books)
        formatted_books = books.map { |book|
          {
            title: book[:title],
            image_url: book[:image_url],
            buttons: [
              {
                type: "postback",
                title: "Select",
                payload: "SELECT_BOOK__#{book[:id]}"
              }
            ]
          }
        }

        {
          attachment: {
            type: "template",
            payload: {
              template_type: "generic",
              elements: formatted_books
            }
          }
        }
      end
    end
  end
end
