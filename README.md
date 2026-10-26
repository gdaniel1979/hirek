# Hírek – Weekly News Digest

This project collects articles from the public RSS feeds of independent Hungarian news outlets (**[HVG](https://hvg.hu/)** and **[Magyar Narancs](https://magyarnarancs.hu/)**), analyzes them with **Claude** (through the Claude Code CLI, using a Claude subscription), generates **summaries and word clouds**, and finally sends **weekly news reports via Gmail**.  
The workflow is automated with a **Bash script** and can be scheduled with `cron`.

---

## Features

- **RSS collection**: Collects the latest articles from public RSS feeds in three categories (the feeds reach back 3–5 days, the covered period is detected automatically):
  - ```🇭🇺``` Belföld (Domestic): HVG
  - 🌍 Külföld (Foreign): HVG, Magyar Narancs
  - 💰 Gazdaság (Economy): HVG
- **AI-based text analysis**: Sends batches of articles to Claude (`sonnet` by default) via `claude -p` and produces a final summary per topic. Usage is billed to the Claude subscription, not to API credits.
- **Batch Processing:** Handles article batches to respect token limits.  
- **WordCloud visualization**: Generates word cloud images from summaries for each topic.
- **Automated email reports**: Sends one combined email with the summaries and embedded word clouds via Gmail API.
- **Pre-flight checks**: Verifies Gmail and Claude authentication before collecting articles, and aborts early with a clear message if either fails.
- **Failure notice**: If a run fails, a short error email is sent so a missed digest does not go unnoticed.
- **Usage tracking**: Logs Claude token usage per run.
- **Automation**: `hirek_automation.sh` runs the script from cron and writes the log.

---

## Project Structure

- ```hirek.py``` -> Main Python script (RSS collection, analysis, wordcloud, email)
- ```hirek_automation.sh``` -> Bash automation script (logging)
- ```prompts.yaml``` -> External YAML file with prompt templates
- ```hungarian_stopwords.txt``` -> Custom Hungarian stopword list (used in WordCloud)
- ```hirek_automation.log``` -> Run logs (with tokens and timestamps)

---

## Requirements

- **Claude Code CLI** installed at ```/home/gdaniel1979/.local/bin/claude``` and a Claude subscription (Pro or higher)
- **Gmail API credentials:**
  - OAuth client secret JSON: ```/home/gdaniel1979/auth/client_secret_XXXX.json```
  - Token file (auto-generated after first login): ```/home/gdaniel1979/auth/gmail_api_token.json```

---

## Authentication Setup
### 1. Claude
Create a long-lived token for unattended (cron) runs:
```
claude setup-token
```
Save the token into ```/home/gdaniel1979/auth/claude_oauth_token.txt``` (```chmod 600```).
If this file is missing, the script falls back to the CLI's own login (```claude auth login```).

### 2. Gmail API
OAuth client secret JSON in ```/home/gdaniel1979/auth/```. 
On the first run, the script will ask for an authentication code. After fisrt run authentication is automatic.

---

## Usage
Automation with script:
```
hirek_automation.sh
```
This will:
- run ```hirek.py```
- save logs to ```hirek_automation.log``` (newest entry on top)

**Cron job** runs every Sunday at 23:00 PM:
```0 23 * * 0 /home/gdaniel1979/my_projects/hirek/hirek_automation.sh```

---

## Logging & Usage Tracking
Each run logs:
- Start/end time
- Duration
- Token usage (prompt & completion)
Example (```hirek_automation.log```):

```yaml
RUN SUMMARY
Script start: 13:09:05
Script end  : 13:22:20
Duration    : 00:13:15
Total tokens used: 102128 (prompt: 66772, completion: 35356)
```

---

## Customization
- **Change topics**: Modify ```TOPICS``` and ```FEEDS``` in ```hirek.py```.
- **Update prompts**: Edit ```prompts.yaml``` to refine the summaries.
- **Model selection**: Change ```claude_model``` in ```hirek.py``` (e.g. ```sonnet```, ```haiku```, ```opus```).
- **Batch size**: Change ```batch_size``` in ```hirek.py``` (default 25 articles per request).
- **Stopwords**: Extend ```hungarian_stopwords.txt``` for better WordCloud filtering.

---

## Email Example
Subject:
```
Heti hírösszefoglaló, 2026-10-13
```
Body (for Külföld, Belföld and Gazdaság):
- Final summary (written by Claude)
- Embedded WordCloud image

---

## Author
**Dániel Galó**
- Data science hobbyist | Python, SQL, Bash learner
- LinkedIn: [linkedin.com/in/danielgalo](https://linkedin.com/in/danielgalo)

---

## License
This project is for personal and educational use only.
Not affiliated with the news outlets whose RSS feeds are used.
