module WikiLinksWikiPagePatch
  # Patches Redmine's WikiPage model to make it more convenient
  # to access the outgoing links from a wiki page.

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable

      has_many :links_from, :class_name => 'WikiLink', :foreign_key => 'from_page_id'
      after_destroy :remove_wiki_links
    end
  end

  module InstanceMethods
    def remove_wiki_links
      WikiLink.remove_from_page(self)
    end

    def links_to
      # all the links that link to this page
      WikiLink
        .where(:wiki_id => self.wiki.id)
        .where(:to_page_title => Wiki.titleize(self.title))
    end
  end

end
