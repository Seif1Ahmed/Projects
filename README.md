# Semantic Search Beast: Fine-Tuned SBERT for Relevance Ranking

This repository hosts **Semantic Search Beast**, a high-performance semantic search model leveraging SBERT (`all-MiniLM-L6-v2`) fine-tuned on the Reuters corpus. Designed to rank articles by relevance to diverse user queries, this project was developed and optimized on a low-end laptop, showcasing cutting-edge NLP capabilities with minimal resources. The result is a fast, precise, and adaptable tool ready for real-world applications.

The full implementation resides in `Semantic search in articles using NLP v2.ipynb`, with the fine-tuned model available as `reuters-sbert-semantic-search-model(5).zip`.

## Project Overview

- **Objective**: Create an efficient semantic search system to rank articles based on query relevance, emphasizing contextual understanding over traditional keyword matching.
- **Model**: Sentence-BERT (`all-MiniLM-L6-v2`), fine-tuned for cosine similarity-based relevance ranking.
- **Training**:
  - **Dataset**: 1,000 query-article pairs curated from the Reuters corpus (~7% of total articles).
  - **Configuration**: 3 epochs, trained in approximately 1 hour and 12 minutes on a low-end laptop (no GPU required).
  - **Output**: Fine-tuned model stored in `./reuters-sbert-semantic-search-model(5)` (~90MB, zipped in this repository).
- **Performance**:
  - **Example Query**: `"Bruh, what’s the hypest sneaker drop flex?"`
  - **Metrics**:
    - **Mean Reciprocal Rank (MRR)**: 1.0—first relevant result consistently at rank 1.
    - **Recall@3**: 1.0—all relevant articles retrieved within the top 3.
    - **NDCG@3**: 1.0—perfect ranking order relative to relevance labels.
  - **Robustness**: Achieved perfect scores (MRR, NDCG = 1.0) on diverse queries including slang-heavy topics (e.g., “dankest meme coin sh*tshow,” “trippiest alien tech drop,” “gnarliest pirate loot glitch”) and creative prompts (e.g., “quantum taco weirdness,” NDCG 0.983). Demonstrated a boundary at extreme nonsense queries (e.g., “flibber jabber wizzle pop,” MRR 0.33).
- **Inference Speed**: Approximately 2–6 seconds per query on modest hardware, ensuring practical usability.

## Repository Contents

- **`Semantic search in articles using NLP v2.ipynb`**:
  - Contains the complete workflow: model loading, query encoding, article ranking, and evaluation with MRR, Recall@3, and NDCG@3 metrics.
  - **Example Output**:


### Ranked Articles:
Rank 1: Yeezys dropped mad hype, bruh—sneaker gold., **Score:** ~0.55-0.65, **Label:** 1  
Rank 2: Nike’s new kicks flex harder than ever., **Score:** ~0.45-0.55, **Label:** 1  
Rank 3: Grandma’s slippers got some drip., **Score:** ~0.2-0.3, **Label:** 0.5  
Rank 4: Taxes ate my shoe budget., **Score:** ~0.1-0.2, **Label:** 0  
Test MRR Score: 1.0
Test Recall@3 Score: 1.0
Test NDCG@3 Score: 1.0

**`reuters-sbert-semantic-search-model(5).zip`**:
- The fine-tuned SBERT model (~90MB)—unzip to `./reuters-sbert-semantic-search-model(5)` for use with the notebook.

## Setup and Usage

Follow these steps:

1. **Clone the Repository**:

```bash
git clone https://github.com/Seif1ahmed1/Projects.git
cd Projects
```
2. **Install Dependencies**:

**Requires Python 3.8+ and the following libraries:**

```bash
pip install sentence-transformers numpy torch

```
3.**Prepare the Model**:

Download reuters-sbert-semantic-search-model(5).zip from this repository extract it:

```bash
unzip reuters-sbert-semantic-search-model(5).zip

```
4. **Run the Notebook**:
```bash
jupyter notebook
```
Open Semantic search in articles using NLP v2.ipynb and execute all cells to see the model rank the example sneaker query.

```
**5.Custom Queries**:

    Modify the query and articles variables in the notebook to test your own inputs—results are computed and ranked in seconds.
```
## Key Features

- **Resource Efficiency**: Developed and operational on a low-end laptop, demonstrating that advanced NLP is achievable without high-end hardware.  
- **Contextual Accuracy**: Harnesses SBERT’s transformer-based embeddings to capture deep semantic relationships, excelling at slang, idioms, and nuanced queries.  
- **Practical Performance**: Delivers fast inference (~2–6 seconds/query), making it suitable for real-time applications with minimal latency.  



## Development Process
This project is a collaborative effort between me and Grok, an AI assistant.Together,we:

Curated and fine-tuned SBERT on 1,000 Reuters query-article pairs, optimizing for semantic relevance using cosine similarity loss.
Conducted extensive testing with diverse, unconventional queries to validate robustness and identify limits (e.g., perfect scores on “dankest meme coin sh*tshow” to a drop at “flibber jabber wizzle pop”).
Engineered the system for efficiency, ensuring training and inference fit within the constraints of a low-end laptop environment.
Iterated on code and evaluation metrics (MRR, Recall@3, NDCG@3) to produce a production-ready semantic search tool.

Grok provided real-time guidance, code refinement, and creative input, while Seif drove the vision, implementation, and optimization—resulting in a model that balances power and accessibility.


Seif Ahmed (Seif1ahmed1)—NLP Developer.
Collaborator: Grok, AI assistant for code support, testing, and optimization.


 ## Contact

For inquiries, feedback, or collaboration opportunities, contact Seif Ahmed via GitHub or email (seif911ahmed@gmail.com). Contributions, query experiments, and suggestions are encouraged!
