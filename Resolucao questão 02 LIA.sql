select
d.nome as departamento, --mostre o nome do departamento
    count(distinct e.matr) as qtd_empregados, --a quantidade de empregados, 
    round(avg(coalesce(v.valor, 0)), 2) as media_salarial, --a média salarial
    round(max(coalesce(v.valor, 0)), 2) as maior_salario, --o maior salários
    round(min(coalesce(v.valor, 0)), 2) as menor_salario --Omenor salários
from departamento d
inner join empregado e on e.lotacao = d.cod_dep
inner join emp_venc ev on ev.matr = e.matr
inner join vencimento v on v.cod_venc = ev.cod_venc
group by d.nome
order by media_salarial desc -- Ordene o resultado pela maior média salarial