require 'pender_client/version'
require 'webmock'
require 'net/http'
module PenderClient
  include WebMock::API

  @host = nil

  def self.host=(host)
    @host = host
  end

  def self.host
    @host
  end

  module Request
    
    # GET /api/medias
    def self.get_medias(host = nil, params = {}, token = '', headers = {})
      request('get', host, '/api/medias', params, token, headers)
    end

    # DELETE /api/medias
    def self.delete_medias(host = nil, params = {}, token = '', headers = {})
      request('delete', host, '/api/medias', params, token, headers)
    end
           
    private

    def self.request(method, host, path, params = {}, token = '', headers = {})
      host ||= PenderClient.host
      uri = URI(host + path)
      klass = 'Net::HTTP::' + method.capitalize
      request = nil

      if method == 'get' || method == 'delete'
        querystr = params.reject{ |k, v| v.blank? }.collect{ |k, v| k.to_s + '=' + CGI::escape(v.to_s) }.reverse.join('&')
        (querystr = '?' + querystr) unless querystr.blank?
        request = klass.constantize.new(uri.path + querystr)
      elsif method == 'post'
        request = klass.constantize.new(uri.path)
        request.set_form_data(params)
      end

      unless token.blank?
        request['X-Pender-Token'] = token.to_s
      end

      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = uri.scheme == 'https'
      response = http.request(request)
      if response.code.to_i === 401
        raise 'Unauthorized'
      else
        JSON.parse(response.body)
      end
    end
  end

  module Mock
    
    def self.mock_medias_returns_parsed_data(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:get, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}, :headers=>{"X-Pender-Token"=>"test"}})
      .to_return(body: '{"type":"media","data":{"comment_count":7,"description":"","title":"MeedanTube","published_at":"2009-03-06T00:44:31.000Z","subscriber_count":140,"video_count":15,"view_count":29278,"thumbnail_url":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","picture":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","country":null,"username":"MeedanTube","subtype":"user","playlists_count":2,"url":"https://www.youtube.com/user/MeedanTube","provider":"youtube","type":"profile","parsed_at":"2016-06-14T20:37:17.604-03:00","favicon":"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube","embed_tag":"\u003cscript src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"\u003e\u003c/script\u003e"}}', status: 200)
      @data = {"type"=>"media", "data"=>{"comment_count"=>7, "description"=>"", "title"=>"MeedanTube", "published_at"=>"2009-03-06T00:44:31.000Z", "subscriber_count"=>140, "video_count"=>15, "view_count"=>29278, "thumbnail_url"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "picture"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "country"=>nil, "username"=>"MeedanTube", "subtype"=>"user", "playlists_count"=>2, "url"=>"https://www.youtube.com/user/MeedanTube", "provider"=>"youtube", "type"=>"profile", "parsed_at"=>"2016-06-14T20:37:17.604-03:00", "favicon"=>"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube", "embed_tag"=>"<script src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"></script>"}}
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_medias_returns_url_not_provided(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:get, host + '/api/medias')
      .with({:query=>{:url=>nil}, :headers=>{"X-Pender-Token"=>"test"}})
      .to_return(body: '{"type":"error","data":{"message":"Parameters missing","code":2}}', status: 400)
      @data = {"type"=>"error", "data"=>{"message"=>"Parameters missing", "code"=>2}}
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_medias_returns_access_denied(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:get, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}})
      .to_return(body: '{"type":"error","data":{"message":"Unauthorized","code":1}}', status: 401)
      @data = {"type"=>"error", "data"=>{"message"=>"Unauthorized", "code"=>1}}
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_medias_returns_timeout(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:get, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}, :headers=>{"X-Pender-Token"=>"test"}})
      .to_return(body: '{"type":"media","data":{"comment_count":7,"description":"","title":"MeedanTube","published_at":"2009-03-06T00:44:31.000Z","subscriber_count":140,"video_count":15,"view_count":29278,"thumbnail_url":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","picture":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","country":null,"username":"MeedanTube","subtype":"user","playlists_count":2,"url":"https://www.youtube.com/user/MeedanTube","provider":"youtube","type":"profile","parsed_at":"2016-06-14T20:37:17.604-03:00","favicon":"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube","embed_tag":"\u003cscript src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"\u003e\u003c/script\u003e"}}', status: 408)
      @data = {"type"=>"media", "data"=>{"comment_count"=>7, "description"=>"", "title"=>"MeedanTube", "published_at"=>"2009-03-06T00:44:31.000Z", "subscriber_count"=>140, "video_count"=>15, "view_count"=>29278, "thumbnail_url"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "picture"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "country"=>nil, "username"=>"MeedanTube", "subtype"=>"user", "playlists_count"=>2, "url"=>"https://www.youtube.com/user/MeedanTube", "provider"=>"youtube", "type"=>"profile", "parsed_at"=>"2016-06-14T20:37:17.604-03:00", "favicon"=>"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube", "embed_tag"=>"<script src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"></script>"}}
      yield
      WebMock.allow_net_connect!
    end
             
    def self.mock_medias_returns_api_limit_reached(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:get, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}, :headers=>{"X-Pender-Token"=>"test"}})
      .to_return(body: '{"type":"media","data":{"comment_count":7,"description":"","title":"MeedanTube","published_at":"2009-03-06T00:44:31.000Z","subscriber_count":140,"video_count":15,"view_count":29278,"thumbnail_url":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","picture":"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg","country":null,"username":"MeedanTube","subtype":"user","playlists_count":2,"url":"https://www.youtube.com/user/MeedanTube","provider":"youtube","type":"profile","parsed_at":"2016-06-14T20:37:17.604-03:00","favicon":"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube","embed_tag":"\u003cscript src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"\u003e\u003c/script\u003e"}}', status: 429)
      @data = {"type"=>"media", "data"=>{"comment_count"=>7, "description"=>"", "title"=>"MeedanTube", "published_at"=>"2009-03-06T00:44:31.000Z", "subscriber_count"=>140, "video_count"=>15, "view_count"=>29278, "thumbnail_url"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "picture"=>"https://yt3.ggpht.com/-MPd3Hrn0msk/AAAAAAAAAAI/AAAAAAAAAAA/I1ftnn68v8U/s88-c-k-no-rj-c0xffffff/photo.jpg", "country"=>nil, "username"=>"MeedanTube", "subtype"=>"user", "playlists_count"=>2, "url"=>"https://www.youtube.com/user/MeedanTube", "provider"=>"youtube", "type"=>"profile", "parsed_at"=>"2016-06-14T20:37:17.604-03:00", "favicon"=>"http://www.google.com/s2/favicons?domain_url=https://www.youtube.com/user/MeedanTube", "embed_tag"=>"<script src=\"http://www.example.com/api/medias.js?url=https%3A%2F%2Fwww.youtube.com%2Fuser%2FMeedanTube\" type=\"text/javascript\"></script>"}}
      yield
      WebMock.allow_net_connect!
    end

    def self.mock_delete_medias_returns_success(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:delete, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}, :headers=>{"X-Pender-Token"=>"test"}})
      .to_return(body: '{"type":"success"}', status: 200)
      @data = {"type"=>"success"}
      yield
      WebMock.allow_net_connect!
    end

    def self.mock_delete_medias_returns_access_denied(host = nil)
      WebMock.disable_net_connect!
      host ||= PenderClient.host
      WebMock.stub_request(:delete, host + '/api/medias')
      .with({:query=>{:url=>"https://www.youtube.com/user/MeedanTube"}})
      .to_return(body: '{"type":"error","data":{"message":"Unauthorized","code":1}}', status: 401)
      @data = {"type"=>"error", "data"=>{"message"=>"Unauthorized", "code"=>1}}
      yield
      WebMock.allow_net_connect!
    end
  end
end
