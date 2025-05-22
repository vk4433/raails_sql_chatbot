from dotenv import load_dotenv
import os
import sys
import google.generativeai as genai

load_dotenv()

genai.configure(api_key=os.getenv("Gemini"))

def query_generator(schema, user_q):
    model = genai.GenerativeModel(model_name="gemini-1.5-flash-002")
    
    prompt = f"""
    You are an expert in writing optimized and accurate MySQL queries.

Given the following database schema:
{schema}

And the user's question:
{user_q}

Generate a valid MySQL query that correctly retrieves or manipulates the data. Ensure the query:
- Uses proper SQL syntax.
- Includes necessary joins, conditions, aggregations, subqueries, etc.
- Is efficient and avoids unnecessary complexity.
- Applies `LIMIT 40` if the result may return more than 40 rows.
- Does **not** apply `LIMIT` for aggregate or count queries.
- If the schema is empty or missing, return exactly: Wrong database selected.

Return only the SQL query, with no explanations, markdown, or formatting.

    """

    response = model.generate_content(prompt).text.strip()
    query = response.replace("```sql", "").replace("```", "").strip()
    return query

 
if __name__ == "__main__":
    schema = sys.argv[1]
    user_question = sys.argv[2]
    query = query_generator(schema, user_question)
    print(query)
