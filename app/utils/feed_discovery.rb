require "feedbag"
require "feedzirra"

class FeedDiscovery
  def discover(url, finder = Feedbag, parser = Feedzirra::Feed)
    urls = [url]
    until urls.empty?
      url  = urls.shift
      feed = get_feed_for_url(url, finder, parser) do
        urls.concat(finder.find(url).take(1))
      end
      feed and return feed
    end
    false
  end

  def get_feed_for_url(url, finder, parser)
    feed = parser.fetch_and_parse(url)
    feed.feed_url ||= url
    feed
  rescue Exception
    yield if block_given?
  end
end
