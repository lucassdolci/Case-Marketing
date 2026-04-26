# 📊 Case: Análise de Performance de Campanhas de Marketing

> **Pergunta de negócio:** Quais campanhas entregam melhor retorno sobre investimento, e como redistribuir o orçamento para maximizar conversões e reduzir o CAC?

---

## 🧭 Contexto

Uma empresa com presença em três grandes plataformas digitais — **Meta**, **YouTube** e **Spotify** — precisava entender onde seu budget de mídia paga estava gerando resultado real. Com campanhas rodando em paralelo e métricas dispersas, a análise foi estruturada para responder objetivamente:

- Quais plataformas entregam o melhor ROAS?
- Quais campanhas têm CAC fora de controle?
- Onde cortar e onde investir mais?

**Período analisado:** Janeiro e Fevereiro de 2025  
**Total de campanhas analisadas:** 18 (3 por plataforma × 2 meses)  
**Budget total:** R$ 141.700

---

## 🛠️ Ferramentas

| Ferramenta     | Uso                                              |
|----------------|--------------------------------------------------|
| **MySQL**      | Extração e análise via 5 queries comentadas      |
| **Power BI**   | Dashboard com 4 páginas e esquema estrela        |
| **Python**     | Validação e exploração do dataset                |
| **Excel/CSV**  | Fonte de dados base                              |
| **GitHub**     | Versionamento e portfólio                        |

---

## 📁 Estrutura do Projeto

```
marketing-performance-case/
│
├── 📂 data/
│   └── campanhas_marketing.csv        # Dataset com 18 linhas
│
├── 📂 sql/
│   └── queries_analise.sql            # 5 queries comentadas (MySQL)
│
├── 📂 powerbi/
│   ├── estrutura_dashboard.md         # Documentação das 4 páginas
│   └── dashboard_marketing.pbix       # Arquivo Power BI
│
├── 📂 docs/
│   └── insights_recomendacoes.md      # 3 insights acionáveis
│
└── README.md
```

---

## 📈 Dashboard — Estrutura (4 Páginas)

### Página 1 — Visão Geral
KPIs consolidados: ROAS total, CAC médio, CTR médio e total de conversões. Gráfico de receita vs investimento por mês com filtros interativos por plataforma e campanha.

### Página 2 — Por Plataforma
Comparativo visual entre Meta, YouTube e Spotify com gráfico de radar, scatter (investimento × receita) e tabela detalhada por plataforma.

### Página 3 — Campanhas
Ranking completo com formatação condicional. Campanhas ruins sinalizadas em vermelho (ROAS < 1.5). Badge de recomendação por status: corte, revisão, monitorar ou manter.

### Página 4 — Redistribuição de Orçamento
Simulador de realocação de budget com projeção de impacto em conversões, CAC e receita. Waterfall chart com ganho estimado pela otimização.

---

## 🗃️ Modelo de Dados — Esquema Estrela

```
dCalendario ──┐
              ├──► fCampanhas (FATO)
dPlataforma ──┤
              │
dCampanha  ───┘
```

**Tabela fato:** `fCampanhas` — investimento, impressões, cliques, conversões, receita  
**Dimensões:** `dPlataforma`, `dCampanha`, `dCalendario`

---

## 🔍 Principais Métricas Analisadas

| Métrica | Fórmula                            | Benchmark       |
|---------|------------------------------------|-----------------|
| ROAS    | receita / investimento             | ≥ 3.0x          |
| CAC     | investimento / conversões          | Depende do ticket|
| CTR     | (cliques / impressões) × 100       | Meta: 0.9% / YT: 0.65% / Spotify: 0.25% |
| ROI     | (receita − investimento) / invest. | > 100%          |
| Taxa Conv.| conversões / cliques             | ≥ 2.0%          |

---

## 💡 Insights Principais

### 1. Meta domina em eficiência de conversão
O retargeting de carrinho e vendas na Meta apresentou ROAS médio de **5.48x**, com CAC de R$ 29–32. Campanhas de prospeccão, por outro lado, tiveram ROAS abaixo de 1.1x — ineficientes para o estágio do funil.

### 2. YouTube gera alcance, mas apenas InStream converte
As campanhas Bumper no YouTube tiveram ROAS de **0.73x em janeiro** — abaixo do ponto de equilíbrio. O volume de impressões (3.5M) não se converte em receita. InStream, com ROAS de 5.48x, é o formato que sustenta a plataforma.

### 3. Spotify Podcast Ads é a joia escondida
Com ROAS de 4.50–4.75x e CAC de R$ 35–40, os Podcast Ads do Spotify superam YouTube e ficam próximos do Meta em eficiência, porém com investimento muito menor. Há espaço claro para escalar essa campanha.

---

## 📊 Resultado da Redistribuição Proposta

| Plataforma | Atual (R$) | Proposto (R$) | Variação |
|------------|------------|----------------|----------|
| Meta       | 48.200     | 63.765 (+45%)  | +32% ↑   |
| YouTube    | 59.200     | 49.595 (35%)   | -16% ↓   |
| Spotify    | 34.300     | 28.340 (20%)   | -17% ↓   |

**Impacto projetado:**
- Conversões: **+18%** (+519/mês)
- CAC: **-22%** (R$55 → R$43)
- Receita: **+24%** (R$591.860 → R$733.906)

---

## ▶️ Como Reproduzir

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/marketing-performance-case

# 2. Importe o CSV no MySQL e execute as queries
mysql -u root -p < sql/queries_analise.sql

# 3. Abra o arquivo .pbix no Power BI Desktop
# Atualize a fonte de dados apontando para /data/campanhas_marketing.csv
```

---

## 👤 Autor

**[Seu Nome]**  
Analista de Dados | SQL · Power BI · Python  
[LinkedIn](https://linkedin.com/in/seu-perfil) · [GitHub](https://github.com/seu-usuario)

---

## 📄 Licença

Este projeto foi desenvolvido para fins de portfólio. Dataset fictício criado para análise.
