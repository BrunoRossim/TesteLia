/*- students: (id int, name text, enrolled_at date, course_id text)
- courses: (id int, name text, price numeric, school_id text)
- schools: (id int, name text) */

/* a. Escreva uma consulta PostgreSQL para obter, por nome da escola e por dia, a quantidade de alunos matriculados e o valor total das matrículas, 
tendo como restrição os cursos que começam com a palavra “data”. 
Ordene o resultado do dia mais recente para o mais antigo.*/

--Resposta para a questão "A"
select schools.name as nome_escola, students.enrolled_at as data_matricula, courses.name as nome_curso
count(students.id) as total_estudantes, sum(courses.price) as total_matricula from students /* nesta parte do codigo, selecionei o nome das escolas,
a data de metricula dos alunos; realizaei a contagem do numero total de alunos matriculados e somei o valor total das matriculas realizadas dando 
o caminho para consulta; renomeei todos os resultados com alias para melhor identificação na lingua portuguesa. */

inner join courses on students.course_id = courses.id
inner join schools on courses.school_id = schools.id /* aqui faço a junção das tabelas de cursos e escolas esclarecendo onde esta a igualdade
de cada junção */

where courses.name like 'data%' -- colocando o filtro para cursos que iniciem com o nome "data"

group by schools.name, students.enrolled_at, courses.name -- agrupando o resultado pelo nome e pela data de matricula

order by students.enrolled_at desc; -- ordenando o resultado pela data mais recente para mais antigo.


/* b.Utilizando a resposta do item a, escreva uma consulta para obter, por escola e por dia, a soma acumulada, a média móvel 7 dias
e a média móvel 30 dias da quantidade de alunos.*/

--Resposta para questão "B"

-- Utilizando a resposta do item a,
with tbl as (
select 
schools.name as nome_escola,
students.enrolled_at as data_matricula,
sum(students.id) as total_estudantes
from students
inner join courses on students.course_id = courses.id
inner join schools on courses.school_id = schools.id
group by schools.name, students.enrolled_at
order by students.enrolled_at desc
)
-- escreva uma consulta para obter, por escola e por dia, a soma acumulada, a média de 7 dias e a média de 30 dias da quantidade de alunos.
select 
nome_escola,
total_estudantes as soma_acumulada,
round(avg(total_estudantes) over (rows between 6 preceding and current row), 2) as movel_7_dias,
round(avg(total_estudantes) over (rows between 29 preceding and current row), 2) as movel_30_dias
from tbl
group by nome_escola, total_estudantes