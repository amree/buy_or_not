module Chats
  module MessageTemplates
    module SearchType
      def ask_for_type_of_search
        {
          attachment: {
            type: "template",
            payload: {
              template_type: "button",
              text: "Do you want to search books by name or by GoodReads ID?",
              buttons: [
                {type: "postback", title: "By name", payload: "SEARCH_BY_NAME"},
                {type: "postback", title: "By GoodReads ID", payload: "SEARCH_BY_GOOD_READS_ID"}
              ]
            }
          }
        }
      end
    end
  end
end
