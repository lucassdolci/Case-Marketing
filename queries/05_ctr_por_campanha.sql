 -- CTR POR CAMPANHA --
-- Fórmula: (cliques / impressoes) * 100
-- Objetivo: Avaliar a relevância criativa e a assertividade
--           da segmentação de cada campanha.

SELECT
    campanha_id,
    nome_campanha,
    plataforma,
    mes_ano,
    impressoes,
    cliques,
    ROUND((cliques / NULLIF(impressoes, 0)) * 100, 4) AS ctr_percentual,
    -- Benchmark de CTR por plataforma (valores de mercado)
    CASE plataforma
        WHEN 'Meta'     THEN 'Benchmark: ~0.90%'
        WHEN 'YouTube'  THEN 'Benchmark: ~0.65%'
        WHEN 'Spotify'  THEN 'Benchmark: ~0.25%'
        ELSE 'Sem benchmark definido'
    END                                                AS benchmark_plataforma
FROM campanhas_marketing
ORDER BY ctr_percentual DESC;