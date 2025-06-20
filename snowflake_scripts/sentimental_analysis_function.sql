CREATE OR REPLACE FUNCTION analyze_sentiments(text STRING)
RETURNS STRING
LANGUAGE PYHTON
RUNTIME_VERSION = '3.11'
PACKAGES = ('textblob')
HANDLER = 'sentiment_analyzer'
AS $$
from textblob import TextBlob
def sentiment_analyzer(text):
    analysis = TextBlob(text)

    if analysis.sentiment.polarity > 0:
        return 'Positive'
    elif analysis.sentiment.polarity == 0:
        return 'Neutral'
    else:
        return 'Negative'
$$;