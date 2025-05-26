class QueryGeneration
  def self.generate_query(schema, user_query)
    schema_text = schema.to_s.gsub('"', '\"')
    user_query_text = user_query.to_s.gsub('"', '\"')

    result = `python3 #{Rails.root.join('python/llm.py')} "#{schema_text}" "#{user_query_text}"`

    result.strip
  end
end
