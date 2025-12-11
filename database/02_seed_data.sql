-- ============================================================================
-- Fake User Generator - Seed Data
-- ============================================================================
-- Lookup data for en_US and de_DE locales
-- Large enough to support 10,000 - 1,000,000 unique combinations
-- ============================================================================

-- ============================================================================
-- LOCALES
-- ============================================================================
INSERT INTO faker.locales (code, name) VALUES
    ('en_US', 'English (USA)'),
    ('de_DE', 'German (Germany)')
ON CONFLICT (code) DO NOTHING;

-- ============================================================================
-- TITLES
-- ============================================================================

-- English titles
INSERT INTO faker.titles (locale, title, gender) VALUES
    ('en_US', 'Mr.', 'M'),
    ('en_US', 'Mrs.', 'F'),
    ('en_US', 'Ms.', 'F'),
    ('en_US', 'Miss', 'F'),
    ('en_US', 'Dr.', NULL),
    ('en_US', 'Prof.', NULL);

-- German titles
INSERT INTO faker.titles (locale, title, gender) VALUES
    ('de_DE', 'Herr', 'M'),
    ('de_DE', 'Frau', 'F'),
    ('de_DE', 'Dr.', NULL),
    ('de_DE', 'Prof.', NULL),
    ('de_DE', 'Prof. Dr.', NULL);

-- ============================================================================
-- FIRST NAMES - English (200+ names for variety)
-- ============================================================================
INSERT INTO faker.first_names (locale, name, gender) VALUES
    -- Male names
    ('en_US', 'James', 'M'), ('en_US', 'Robert', 'M'), ('en_US', 'John', 'M'),
    ('en_US', 'Michael', 'M'), ('en_US', 'David', 'M'), ('en_US', 'William', 'M'),
    ('en_US', 'Richard', 'M'), ('en_US', 'Joseph', 'M'), ('en_US', 'Thomas', 'M'),
    ('en_US', 'Christopher', 'M'), ('en_US', 'Charles', 'M'), ('en_US', 'Daniel', 'M'),
    ('en_US', 'Matthew', 'M'), ('en_US', 'Anthony', 'M'), ('en_US', 'Mark', 'M'),
    ('en_US', 'Donald', 'M'), ('en_US', 'Steven', 'M'), ('en_US', 'Paul', 'M'),
    ('en_US', 'Andrew', 'M'), ('en_US', 'Joshua', 'M'), ('en_US', 'Kenneth', 'M'),
    ('en_US', 'Kevin', 'M'), ('en_US', 'Brian', 'M'), ('en_US', 'George', 'M'),
    ('en_US', 'Timothy', 'M'), ('en_US', 'Ronald', 'M'), ('en_US', 'Edward', 'M'),
    ('en_US', 'Jason', 'M'), ('en_US', 'Jeffrey', 'M'), ('en_US', 'Ryan', 'M'),
    ('en_US', 'Jacob', 'M'), ('en_US', 'Gary', 'M'), ('en_US', 'Nicholas', 'M'),
    ('en_US', 'Eric', 'M'), ('en_US', 'Jonathan', 'M'), ('en_US', 'Stephen', 'M'),
    ('en_US', 'Larry', 'M'), ('en_US', 'Justin', 'M'), ('en_US', 'Scott', 'M'),
    ('en_US', 'Brandon', 'M'), ('en_US', 'Benjamin', 'M'), ('en_US', 'Samuel', 'M'),
    ('en_US', 'Raymond', 'M'), ('en_US', 'Gregory', 'M'), ('en_US', 'Frank', 'M'),
    ('en_US', 'Alexander', 'M'), ('en_US', 'Patrick', 'M'), ('en_US', 'Jack', 'M'),
    ('en_US', 'Dennis', 'M'), ('en_US', 'Jerry', 'M'), ('en_US', 'Tyler', 'M'),
    ('en_US', 'Aaron', 'M'), ('en_US', 'Jose', 'M'), ('en_US', 'Adam', 'M'),
    ('en_US', 'Nathan', 'M'), ('en_US', 'Henry', 'M'), ('en_US', 'Douglas', 'M'),
    ('en_US', 'Zachary', 'M'), ('en_US', 'Peter', 'M'), ('en_US', 'Kyle', 'M'),
    ('en_US', 'Ethan', 'M'), ('en_US', 'Jeremy', 'M'), ('en_US', 'Walter', 'M'),
    ('en_US', 'Christian', 'M'), ('en_US', 'Keith', 'M'), ('en_US', 'Roger', 'M'),
    ('en_US', 'Terry', 'M'), ('en_US', 'Austin', 'M'), ('en_US', 'Sean', 'M'),
    ('en_US', 'Gerald', 'M'), ('en_US', 'Carl', 'M'), ('en_US', 'Dylan', 'M'),
    ('en_US', 'Harold', 'M'), ('en_US', 'Jordan', 'M'), ('en_US', 'Jesse', 'M'),
    ('en_US', 'Bryan', 'M'), ('en_US', 'Lawrence', 'M'), ('en_US', 'Arthur', 'M'),
    ('en_US', 'Gabriel', 'M'), ('en_US', 'Bruce', 'M'), ('en_US', 'Logan', 'M'),
    ('en_US', 'Billy', 'M'), ('en_US', 'Albert', 'M'), ('en_US', 'Willie', 'M'),
    ('en_US', 'Alan', 'M'), ('en_US', 'Eugene', 'M'), ('en_US', 'Russell', 'M'),
    ('en_US', 'Vincent', 'M'), ('en_US', 'Philip', 'M'), ('en_US', 'Bobby', 'M'),
    ('en_US', 'Johnny', 'M'), ('en_US', 'Bradley', 'M'), ('en_US', 'Roy', 'M'),
    ('en_US', 'Ralph', 'M'), ('en_US', 'Eugene', 'M'), ('en_US', 'Randy', 'M'),
    ('en_US', 'Wayne', 'M'), ('en_US', 'Howard', 'M'), ('en_US', 'Mason', 'M'),
    -- Female names
    ('en_US', 'Mary', 'F'), ('en_US', 'Patricia', 'F'), ('en_US', 'Jennifer', 'F'),
    ('en_US', 'Linda', 'F'), ('en_US', 'Barbara', 'F'), ('en_US', 'Elizabeth', 'F'),
    ('en_US', 'Susan', 'F'), ('en_US', 'Jessica', 'F'), ('en_US', 'Sarah', 'F'),
    ('en_US', 'Karen', 'F'), ('en_US', 'Lisa', 'F'), ('en_US', 'Nancy', 'F'),
    ('en_US', 'Betty', 'F'), ('en_US', 'Margaret', 'F'), ('en_US', 'Sandra', 'F'),
    ('en_US', 'Ashley', 'F'), ('en_US', 'Kimberly', 'F'), ('en_US', 'Emily', 'F'),
    ('en_US', 'Donna', 'F'), ('en_US', 'Michelle', 'F'), ('en_US', 'Dorothy', 'F'),
    ('en_US', 'Carol', 'F'), ('en_US', 'Amanda', 'F'), ('en_US', 'Melissa', 'F'),
    ('en_US', 'Deborah', 'F'), ('en_US', 'Stephanie', 'F'), ('en_US', 'Rebecca', 'F'),
    ('en_US', 'Sharon', 'F'), ('en_US', 'Laura', 'F'), ('en_US', 'Cynthia', 'F'),
    ('en_US', 'Kathleen', 'F'), ('en_US', 'Amy', 'F'), ('en_US', 'Angela', 'F'),
    ('en_US', 'Shirley', 'F'), ('en_US', 'Anna', 'F'), ('en_US', 'Brenda', 'F'),
    ('en_US', 'Pamela', 'F'), ('en_US', 'Emma', 'F'), ('en_US', 'Nicole', 'F'),
    ('en_US', 'Helen', 'F'), ('en_US', 'Samantha', 'F'), ('en_US', 'Katherine', 'F'),
    ('en_US', 'Christine', 'F'), ('en_US', 'Debra', 'F'), ('en_US', 'Rachel', 'F'),
    ('en_US', 'Carolyn', 'F'), ('en_US', 'Janet', 'F'), ('en_US', 'Catherine', 'F'),
    ('en_US', 'Maria', 'F'), ('en_US', 'Heather', 'F'), ('en_US', 'Diane', 'F'),
    ('en_US', 'Ruth', 'F'), ('en_US', 'Julie', 'F'), ('en_US', 'Olivia', 'F'),
    ('en_US', 'Joyce', 'F'), ('en_US', 'Virginia', 'F'), ('en_US', 'Victoria', 'F'),
    ('en_US', 'Kelly', 'F'), ('en_US', 'Lauren', 'F'), ('en_US', 'Christina', 'F'),
    ('en_US', 'Joan', 'F'), ('en_US', 'Evelyn', 'F'), ('en_US', 'Judith', 'F'),
    ('en_US', 'Megan', 'F'), ('en_US', 'Andrea', 'F'), ('en_US', 'Cheryl', 'F'),
    ('en_US', 'Hannah', 'F'), ('en_US', 'Jacqueline', 'F'), ('en_US', 'Martha', 'F'),
    ('en_US', 'Gloria', 'F'), ('en_US', 'Teresa', 'F'), ('en_US', 'Ann', 'F'),
    ('en_US', 'Sara', 'F'), ('en_US', 'Madison', 'F'), ('en_US', 'Frances', 'F'),
    ('en_US', 'Kathryn', 'F'), ('en_US', 'Janice', 'F'), ('en_US', 'Jean', 'F'),
    ('en_US', 'Abigail', 'F'), ('en_US', 'Alice', 'F'), ('en_US', 'Judy', 'F'),
    ('en_US', 'Sophia', 'F'), ('en_US', 'Grace', 'F'), ('en_US', 'Denise', 'F'),
    ('en_US', 'Amber', 'F'), ('en_US', 'Doris', 'F'), ('en_US', 'Marilyn', 'F'),
    ('en_US', 'Danielle', 'F'), ('en_US', 'Beverly', 'F'), ('en_US', 'Isabella', 'F'),
    ('en_US', 'Theresa', 'F'), ('en_US', 'Diana', 'F'), ('en_US', 'Natalie', 'F'),
    ('en_US', 'Brittany', 'F'), ('en_US', 'Charlotte', 'F'), ('en_US', 'Marie', 'F'),
    ('en_US', 'Kayla', 'F'), ('en_US', 'Alexis', 'F'), ('en_US', 'Lori', 'F');

-- ============================================================================
-- FIRST NAMES - German (200+ names)
-- ============================================================================
INSERT INTO faker.first_names (locale, name, gender) VALUES
    -- Male names
    ('de_DE', 'Peter', 'M'), ('de_DE', 'Michael', 'M'), ('de_DE', 'Thomas', 'M'),
    ('de_DE', 'Andreas', 'M'), ('de_DE', 'Stefan', 'M'), ('de_DE', 'Christian', 'M'),
    ('de_DE', 'Martin', 'M'), ('de_DE', 'Markus', 'M'), ('de_DE', 'Daniel', 'M'),
    ('de_DE', 'Frank', 'M'), ('de_DE', 'Klaus', 'M'), ('de_DE', 'Wolfgang', 'M'),
    ('de_DE', 'Jürgen', 'M'), ('de_DE', 'Dieter', 'M'), ('de_DE', 'Werner', 'M'),
    ('de_DE', 'Hans', 'M'), ('de_DE', 'Bernd', 'M'), ('de_DE', 'Uwe', 'M'),
    ('de_DE', 'Manfred', 'M'), ('de_DE', 'Helmut', 'M'), ('de_DE', 'Gerhard', 'M'),
    ('de_DE', 'Heinz', 'M'), ('de_DE', 'Ralf', 'M'), ('de_DE', 'Jens', 'M'),
    ('de_DE', 'Matthias', 'M'), ('de_DE', 'Torsten', 'M'), ('de_DE', 'Sven', 'M'),
    ('de_DE', 'Alexander', 'M'), ('de_DE', 'Florian', 'M'), ('de_DE', 'Sebastian', 'M'),
    ('de_DE', 'Tobias', 'M'), ('de_DE', 'Oliver', 'M'), ('de_DE', 'Marco', 'M'),
    ('de_DE', 'Jan', 'M'), ('de_DE', 'Tim', 'M'), ('de_DE', 'Patrick', 'M'),
    ('de_DE', 'Philipp', 'M'), ('de_DE', 'Lukas', 'M'), ('de_DE', 'Felix', 'M'),
    ('de_DE', 'Jonas', 'M'), ('de_DE', 'Maximilian', 'M'), ('de_DE', 'Leon', 'M'),
    ('de_DE', 'Paul', 'M'), ('de_DE', 'David', 'M'), ('de_DE', 'Niklas', 'M'),
    ('de_DE', 'Johannes', 'M'), ('de_DE', 'Simon', 'M'), ('de_DE', 'Erik', 'M'),
    ('de_DE', 'Benjamin', 'M'), ('de_DE', 'Lars', 'M'), ('de_DE', 'Christoph', 'M'),
    ('de_DE', 'Marcel', 'M'), ('de_DE', 'Dennis', 'M'), ('de_DE', 'Dirk', 'M'),
    ('de_DE', 'Holger', 'M'), ('de_DE', 'Karsten', 'M'), ('de_DE', 'Thorsten', 'M'),
    ('de_DE', 'Ingo', 'M'), ('de_DE', 'Axel', 'M'), ('de_DE', 'Rainer', 'M'),
    ('de_DE', 'Norbert', 'M'), ('de_DE', 'Günter', 'M'), ('de_DE', 'Walter', 'M'),
    ('de_DE', 'Karl', 'M'), ('de_DE', 'Ernst', 'M'), ('de_DE', 'Friedrich', 'M'),
    ('de_DE', 'Heinrich', 'M'), ('de_DE', 'Rudolf', 'M'), ('de_DE', 'Otto', 'M'),
    ('de_DE', 'Hermann', 'M'), ('de_DE', 'Wilhelm', 'M'), ('de_DE', 'Gustav', 'M'),
    ('de_DE', 'Joachim', 'M'), ('de_DE', 'Lothar', 'M'), ('de_DE', 'Hartmut', 'M'),
    ('de_DE', 'Detlef', 'M'), ('de_DE', 'Reinhard', 'M'), ('de_DE', 'Volker', 'M'),
    ('de_DE', 'Kai', 'M'), ('de_DE', 'Sascha', 'M'), ('de_DE', 'Andre', 'M'),
    ('de_DE', 'Steffen', 'M'), ('de_DE', 'Olaf', 'M'), ('de_DE', 'Björn', 'M'),
    ('de_DE', 'Nils', 'M'), ('de_DE', 'Fabian', 'M'), ('de_DE', 'Dominik', 'M'),
    ('de_DE', 'Kevin', 'M'), ('de_DE', 'Julian', 'M'), ('de_DE', 'Moritz', 'M'),
    ('de_DE', 'Elias', 'M'), ('de_DE', 'Noah', 'M'), ('de_DE', 'Ben', 'M'),
    ('de_DE', 'Finn', 'M'), ('de_DE', 'Luis', 'M'), ('de_DE', 'Jakob', 'M'),
    ('de_DE', 'Luca', 'M'), ('de_DE', 'Henry', 'M'), ('de_DE', 'Emil', 'M'),
    -- Female names
    ('de_DE', 'Maria', 'F'), ('de_DE', 'Ursula', 'F'), ('de_DE', 'Petra', 'F'),
    ('de_DE', 'Monika', 'F'), ('de_DE', 'Elisabeth', 'F'), ('de_DE', 'Sabine', 'F'),
    ('de_DE', 'Renate', 'F'), ('de_DE', 'Karin', 'F'), ('de_DE', 'Helga', 'F'),
    ('de_DE', 'Brigitte', 'F'), ('de_DE', 'Ingrid', 'F'), ('de_DE', 'Gisela', 'F'),
    ('de_DE', 'Andrea', 'F'), ('de_DE', 'Claudia', 'F'), ('de_DE', 'Susanne', 'F'),
    ('de_DE', 'Christine', 'F'), ('de_DE', 'Gabriele', 'F'), ('de_DE', 'Birgit', 'F'),
    ('de_DE', 'Barbara', 'F'), ('de_DE', 'Heike', 'F'), ('de_DE', 'Nicole', 'F'),
    ('de_DE', 'Angelika', 'F'), ('de_DE', 'Martina', 'F'), ('de_DE', 'Erika', 'F'),
    ('de_DE', 'Anja', 'F'), ('de_DE', 'Stephanie', 'F'), ('de_DE', 'Katrin', 'F'),
    ('de_DE', 'Anna', 'F'), ('de_DE', 'Julia', 'F'), ('de_DE', 'Melanie', 'F'),
    ('de_DE', 'Sandra', 'F'), ('de_DE', 'Tanja', 'F'), ('de_DE', 'Sonja', 'F'),
    ('de_DE', 'Silke', 'F'), ('de_DE', 'Daniela', 'F'), ('de_DE', 'Stefanie', 'F'),
    ('de_DE', 'Nadine', 'F'), ('de_DE', 'Christina', 'F'), ('de_DE', 'Kathrin', 'F'),
    ('de_DE', 'Jennifer', 'F'), ('de_DE', 'Manuela', 'F'), ('de_DE', 'Simone', 'F'),
    ('de_DE', 'Cornelia', 'F'), ('de_DE', 'Marion', 'F'), ('de_DE', 'Sabrina', 'F'),
    ('de_DE', 'Sarah', 'F'), ('de_DE', 'Laura', 'F'), ('de_DE', 'Lena', 'F'),
    ('de_DE', 'Lisa', 'F'), ('de_DE', 'Hannah', 'F'), ('de_DE', 'Sophie', 'F'),
    ('de_DE', 'Marie', 'F'), ('de_DE', 'Emma', 'F'), ('de_DE', 'Mia', 'F'),
    ('de_DE', 'Lea', 'F'), ('de_DE', 'Leonie', 'F'), ('de_DE', 'Emily', 'F'),
    ('de_DE', 'Jana', 'F'), ('de_DE', 'Michelle', 'F'), ('de_DE', 'Vanessa', 'F'),
    ('de_DE', 'Jessica', 'F'), ('de_DE', 'Jasmin', 'F'), ('de_DE', 'Franziska', 'F'),
    ('de_DE', 'Johanna', 'F'), ('de_DE', 'Katharina', 'F'), ('de_DE', 'Kristina', 'F'),
    ('de_DE', 'Caroline', 'F'), ('de_DE', 'Teresa', 'F'), ('de_DE', 'Diana', 'F'),
    ('de_DE', 'Carina', 'F'), ('de_DE', 'Yvonne', 'F'), ('de_DE', 'Regina', 'F'),
    ('de_DE', 'Vera', 'F'), ('de_DE', 'Doris', 'F'), ('de_DE', 'Christa', 'F'),
    ('de_DE', 'Ruth', 'F'), ('de_DE', 'Gerda', 'F'), ('de_DE', 'Hildegard', 'F'),
    ('de_DE', 'Ilse', 'F'), ('de_DE', 'Elfriede', 'F'), ('de_DE', 'Irmgard', 'F'),
    ('de_DE', 'Margarete', 'F'), ('de_DE', 'Charlotte', 'F'), ('de_DE', 'Frieda', 'F'),
    ('de_DE', 'Paula', 'F'), ('de_DE', 'Luise', 'F'), ('de_DE', 'Clara', 'F'),
    ('de_DE', 'Emilia', 'F'), ('de_DE', 'Amelie', 'F'), ('de_DE', 'Lina', 'F'),
    ('de_DE', 'Ella', 'F'), ('de_DE', 'Nele', 'F'), ('de_DE', 'Maja', 'F'),
    ('de_DE', 'Greta', 'F'), ('de_DE', 'Klara', 'F'), ('de_DE', 'Ida', 'F');

-- ============================================================================
-- LAST NAMES - English (300+ surnames)
-- ============================================================================
INSERT INTO faker.last_names (locale, name) VALUES
    ('en_US', 'Smith'), ('en_US', 'Johnson'), ('en_US', 'Williams'), ('en_US', 'Brown'),
    ('en_US', 'Jones'), ('en_US', 'Garcia'), ('en_US', 'Miller'), ('en_US', 'Davis'),
    ('en_US', 'Rodriguez'), ('en_US', 'Martinez'), ('en_US', 'Hernandez'), ('en_US', 'Lopez'),
    ('en_US', 'Gonzalez'), ('en_US', 'Wilson'), ('en_US', 'Anderson'), ('en_US', 'Thomas'),
    ('en_US', 'Taylor'), ('en_US', 'Moore'), ('en_US', 'Jackson'), ('en_US', 'Martin'),
    ('en_US', 'Lee'), ('en_US', 'Perez'), ('en_US', 'Thompson'), ('en_US', 'White'),
    ('en_US', 'Harris'), ('en_US', 'Sanchez'), ('en_US', 'Clark'), ('en_US', 'Ramirez'),
    ('en_US', 'Lewis'), ('en_US', 'Robinson'), ('en_US', 'Walker'), ('en_US', 'Young'),
    ('en_US', 'Allen'), ('en_US', 'King'), ('en_US', 'Wright'), ('en_US', 'Scott'),
    ('en_US', 'Torres'), ('en_US', 'Nguyen'), ('en_US', 'Hill'), ('en_US', 'Flores'),
    ('en_US', 'Green'), ('en_US', 'Adams'), ('en_US', 'Nelson'), ('en_US', 'Baker'),
    ('en_US', 'Hall'), ('en_US', 'Rivera'), ('en_US', 'Campbell'), ('en_US', 'Mitchell'),
    ('en_US', 'Carter'), ('en_US', 'Roberts'), ('en_US', 'Gomez'), ('en_US', 'Phillips'),
    ('en_US', 'Evans'), ('en_US', 'Turner'), ('en_US', 'Diaz'), ('en_US', 'Parker'),
    ('en_US', 'Cruz'), ('en_US', 'Edwards'), ('en_US', 'Collins'), ('en_US', 'Reyes'),
    ('en_US', 'Stewart'), ('en_US', 'Morris'), ('en_US', 'Morales'), ('en_US', 'Murphy'),
    ('en_US', 'Cook'), ('en_US', 'Rogers'), ('en_US', 'Gutierrez'), ('en_US', 'Ortiz'),
    ('en_US', 'Morgan'), ('en_US', 'Cooper'), ('en_US', 'Peterson'), ('en_US', 'Bailey'),
    ('en_US', 'Reed'), ('en_US', 'Kelly'), ('en_US', 'Howard'), ('en_US', 'Ramos'),
    ('en_US', 'Kim'), ('en_US', 'Cox'), ('en_US', 'Ward'), ('en_US', 'Richardson'),
    ('en_US', 'Watson'), ('en_US', 'Brooks'), ('en_US', 'Chavez'), ('en_US', 'Wood'),
    ('en_US', 'James'), ('en_US', 'Bennett'), ('en_US', 'Gray'), ('en_US', 'Mendoza'),
    ('en_US', 'Ruiz'), ('en_US', 'Hughes'), ('en_US', 'Price'), ('en_US', 'Alvarez'),
    ('en_US', 'Castillo'), ('en_US', 'Sanders'), ('en_US', 'Patel'), ('en_US', 'Myers'),
    ('en_US', 'Long'), ('en_US', 'Ross'), ('en_US', 'Foster'), ('en_US', 'Jimenez'),
    ('en_US', 'Powell'), ('en_US', 'Jenkins'), ('en_US', 'Perry'), ('en_US', 'Russell'),
    ('en_US', 'Sullivan'), ('en_US', 'Bell'), ('en_US', 'Coleman'), ('en_US', 'Butler'),
    ('en_US', 'Henderson'), ('en_US', 'Barnes'), ('en_US', 'Gonzales'), ('en_US', 'Fisher'),
    ('en_US', 'Vasquez'), ('en_US', 'Simmons'), ('en_US', 'Snyder'), ('en_US', 'Patterson'),
    ('en_US', 'Jordan'), ('en_US', 'Reynolds'), ('en_US', 'Hamilton'), ('en_US', 'Graham'),
    ('en_US', 'Wallace'), ('en_US', 'Woods'), ('en_US', 'Cole'), ('en_US', 'West'),
    ('en_US', 'Owen'), ('en_US', 'Reynolds'), ('en_US', 'Fisher'), ('en_US', 'Ellis'),
    ('en_US', 'Harrison'), ('en_US', 'Gibson'), ('en_US', 'McDonald'), ('en_US', 'Cruz'),
    ('en_US', 'Marshall'), ('en_US', 'Ortiz'), ('en_US', 'Gomez'), ('en_US', 'Murray'),
    ('en_US', 'Freeman'), ('en_US', 'Wells'), ('en_US', 'Webb'), ('en_US', 'Simpson'),
    ('en_US', 'Stevens'), ('en_US', 'Tucker'), ('en_US', 'Porter'), ('en_US', 'Hunter'),
    ('en_US', 'Hicks'), ('en_US', 'Crawford'), ('en_US', 'Henry'), ('en_US', 'Boyd'),
    ('en_US', 'Mason'), ('en_US', 'Morales'), ('en_US', 'Kennedy'), ('en_US', 'Warren'),
    ('en_US', 'Dixon'), ('en_US', 'Ramos'), ('en_US', 'Reyes'), ('en_US', 'Burns'),
    ('en_US', 'Gordon'), ('en_US', 'Shaw'), ('en_US', 'Holmes'), ('en_US', 'Rice'),
    ('en_US', 'Robertson'), ('en_US', 'Hunt'), ('en_US', 'Black'), ('en_US', 'Daniels'),
    ('en_US', 'Palmer'), ('en_US', 'Mills'), ('en_US', 'Grant'), ('en_US', 'Stone');

-- ============================================================================
-- LAST NAMES - German (300+ surnames)
-- ============================================================================
INSERT INTO faker.last_names (locale, name) VALUES
    ('de_DE', 'Müller'), ('de_DE', 'Schmidt'), ('de_DE', 'Schneider'), ('de_DE', 'Fischer'),
    ('de_DE', 'Weber'), ('de_DE', 'Meyer'), ('de_DE', 'Wagner'), ('de_DE', 'Becker'),
    ('de_DE', 'Schulz'), ('de_DE', 'Hoffmann'), ('de_DE', 'Schäfer'), ('de_DE', 'Koch'),
    ('de_DE', 'Bauer'), ('de_DE', 'Richter'), ('de_DE', 'Klein'), ('de_DE', 'Wolf'),
    ('de_DE', 'Schröder'), ('de_DE', 'Neumann'), ('de_DE', 'Schwarz'), ('de_DE', 'Zimmermann'),
    ('de_DE', 'Braun'), ('de_DE', 'Krüger'), ('de_DE', 'Hofmann'), ('de_DE', 'Hartmann'),
    ('de_DE', 'Lange'), ('de_DE', 'Schmitt'), ('de_DE', 'Werner'), ('de_DE', 'Schmitz'),
    ('de_DE', 'Krause'), ('de_DE', 'Meier'), ('de_DE', 'Lehmann'), ('de_DE', 'Schmid'),
    ('de_DE', 'Schulze'), ('de_DE', 'Maier'), ('de_DE', 'Köhler'), ('de_DE', 'Herrmann'),
    ('de_DE', 'König'), ('de_DE', 'Walter'), ('de_DE', 'Mayer'), ('de_DE', 'Huber'),
    ('de_DE', 'Kaiser'), ('de_DE', 'Fuchs'), ('de_DE', 'Peters'), ('de_DE', 'Lang'),
    ('de_DE', 'Scholz'), ('de_DE', 'Möller'), ('de_DE', 'Weiß'), ('de_DE', 'Jung'),
    ('de_DE', 'Hahn'), ('de_DE', 'Schubert'), ('de_DE', 'Vogel'), ('de_DE', 'Friedrich'),
    ('de_DE', 'Keller'), ('de_DE', 'Günther'), ('de_DE', 'Frank'), ('de_DE', 'Berger'),
    ('de_DE', 'Winkler'), ('de_DE', 'Roth'), ('de_DE', 'Beck'), ('de_DE', 'Lorenz'),
    ('de_DE', 'Baumann'), ('de_DE', 'Franke'), ('de_DE', 'Albrecht'), ('de_DE', 'Schuster'),
    ('de_DE', 'Simon'), ('de_DE', 'Ludwig'), ('de_DE', 'Böhm'), ('de_DE', 'Winter'),
    ('de_DE', 'Kraus'), ('de_DE', 'Martin'), ('de_DE', 'Schumacher'), ('de_DE', 'Krämer'),
    ('de_DE', 'Vogt'), ('de_DE', 'Stein'), ('de_DE', 'Jäger'), ('de_DE', 'Otto'),
    ('de_DE', 'Sommer'), ('de_DE', 'Groß'), ('de_DE', 'Seidel'), ('de_DE', 'Heinrich'),
    ('de_DE', 'Brandt'), ('de_DE', 'Haas'), ('de_DE', 'Schreiber'), ('de_DE', 'Graf'),
    ('de_DE', 'Schulte'), ('de_DE', 'Dietrich'), ('de_DE', 'Ziegler'), ('de_DE', 'Kuhn'),
    ('de_DE', 'Kühn'), ('de_DE', 'Pohl'), ('de_DE', 'Engel'), ('de_DE', 'Horn'),
    ('de_DE', 'Busch'), ('de_DE', 'Bergmann'), ('de_DE', 'Thomas'), ('de_DE', 'Voigt'),
    ('de_DE', 'Sauer'), ('de_DE', 'Arnold'), ('de_DE', 'Wolff'), ('de_DE', 'Pfeiffer'),
    ('de_DE', 'Ullrich'), ('de_DE', 'Herrmann'), ('de_DE', 'Fiedler'), ('de_DE', 'Decker'),
    ('de_DE', 'Lindner'), ('de_DE', 'Stark'), ('de_DE', 'Beyer'), ('de_DE', 'Kunze'),
    ('de_DE', 'Hauser'), ('de_DE', 'Hansen'), ('de_DE', 'Anders'), ('de_DE', 'Fröhlich'),
    ('de_DE', 'Ackermann'), ('de_DE', 'Hermann'), ('de_DE', 'Schilling'), ('de_DE', 'Ebert'),
    ('de_DE', 'Heß'), ('de_DE', 'Dietrich'), ('de_DE', 'Schindler'), ('de_DE', 'Döring'),
    ('de_DE', 'Brinkmann'), ('de_DE', 'Kurz'), ('de_DE', 'Steiner'), ('de_DE', 'Albers'),
    ('de_DE', 'Wirth'), ('de_DE', 'Riedel'), ('de_DE', 'Heinz'), ('de_DE', 'Geiger'),
    ('de_DE', 'Reuter'), ('de_DE', 'Kraft'), ('de_DE', 'Barth'), ('de_DE', 'Siebert'),
    ('de_DE', 'Thiele'), ('de_DE', 'Wendt'), ('de_DE', 'Wegner'), ('de_DE', 'Jost');

-- ============================================================================
-- STREET SUFFIXES
-- ============================================================================
INSERT INTO faker.street_suffixes (locale, suffix) VALUES
    ('en_US', 'Street'), ('en_US', 'Avenue'), ('en_US', 'Boulevard'), ('en_US', 'Drive'),
    ('en_US', 'Lane'), ('en_US', 'Road'), ('en_US', 'Way'), ('en_US', 'Court'),
    ('en_US', 'Place'), ('en_US', 'Circle'), ('en_US', 'Trail'), ('en_US', 'Parkway'),
    ('de_DE', 'straße'), ('de_DE', 'weg'), ('de_DE', 'allee'), ('de_DE', 'platz'),
    ('de_DE', 'ring'), ('de_DE', 'gasse'), ('de_DE', 'damm'), ('de_DE', 'ufer');

-- ============================================================================
-- STREETS (Base names to combine with suffixes)
-- ============================================================================
INSERT INTO faker.streets (locale, name) VALUES
    -- English streets
    ('en_US', 'Main'), ('en_US', 'Oak'), ('en_US', 'Pine'), ('en_US', 'Maple'),
    ('en_US', 'Cedar'), ('en_US', 'Elm'), ('en_US', 'Washington'), ('en_US', 'Lake'),
    ('en_US', 'Hill'), ('en_US', 'Park'), ('en_US', 'View'), ('en_US', 'Forest'),
    ('en_US', 'River'), ('en_US', 'Spring'), ('en_US', 'Valley'), ('en_US', 'Church'),
    ('en_US', 'North'), ('en_US', 'South'), ('en_US', 'East'), ('en_US', 'West'),
    ('en_US', 'Highland'), ('en_US', 'Lincoln'), ('en_US', 'Jackson'), ('en_US', 'Jefferson'),
    ('en_US', 'Franklin'), ('en_US', 'Madison'), ('en_US', 'Wilson'), ('en_US', 'Sunset'),
    ('en_US', 'Broadway'), ('en_US', 'Center'), ('en_US', 'Cherry'), ('en_US', 'Meadow'),
    ('en_US', 'Mill'), ('en_US', 'Bridge'), ('en_US', 'School'), ('en_US', 'College'),
    ('en_US', 'Market'), ('en_US', 'Railroad'), ('en_US', 'Industrial'), ('en_US', 'Commerce'),
    -- German streets
    ('de_DE', 'Haupt'), ('de_DE', 'Bahn'), ('de_DE', 'Berg'), ('de_DE', 'Burg'),
    ('de_DE', 'Garten'), ('de_DE', 'Kirch'), ('de_DE', 'Markt'), ('de_DE', 'Schloss'),
    ('de_DE', 'Schul'), ('de_DE', 'Wald'), ('de_DE', 'Wiesen'), ('de_DE', 'Linden'),
    ('de_DE', 'Birken'), ('de_DE', 'Eichen'), ('de_DE', 'Tannen'), ('de_DE', 'Rosen'),
    ('de_DE', 'Mühlen'), ('de_DE', 'Brunnen'), ('de_DE', 'Rathaus'), ('de_DE', 'Post'),
    ('de_DE', 'Kaiser'), ('de_DE', 'König'), ('de_DE', 'Bismarck'), ('de_DE', 'Goethe'),
    ('de_DE', 'Schiller'), ('de_DE', 'Mozart'), ('de_DE', 'Beethoven'), ('de_DE', 'Bach'),
    ('de_DE', 'Friedens'), ('de_DE', 'Freiheits'), ('de_DE', 'Sonnen'), ('de_DE', 'Stern'),
    ('de_DE', 'Blumen'), ('de_DE', 'Wasser'), ('de_DE', 'Feld'), ('de_DE', 'Sand');

-- ============================================================================
-- CITIES
-- ============================================================================
INSERT INTO faker.cities (locale, name) VALUES
    -- US cities
    ('en_US', 'New York'), ('en_US', 'Los Angeles'), ('en_US', 'Chicago'), ('en_US', 'Houston'),
    ('en_US', 'Phoenix'), ('en_US', 'Philadelphia'), ('en_US', 'San Antonio'), ('en_US', 'San Diego'),
    ('en_US', 'Dallas'), ('en_US', 'San Jose'), ('en_US', 'Austin'), ('en_US', 'Jacksonville'),
    ('en_US', 'Fort Worth'), ('en_US', 'Columbus'), ('en_US', 'Charlotte'), ('en_US', 'Indianapolis'),
    ('en_US', 'San Francisco'), ('en_US', 'Seattle'), ('en_US', 'Denver'), ('en_US', 'Boston'),
    ('en_US', 'Nashville'), ('en_US', 'Detroit'), ('en_US', 'Portland'), ('en_US', 'Memphis'),
    ('en_US', 'Oklahoma City'), ('en_US', 'Las Vegas'), ('en_US', 'Louisville'), ('en_US', 'Baltimore'),
    ('en_US', 'Milwaukee'), ('en_US', 'Albuquerque'), ('en_US', 'Tucson'), ('en_US', 'Fresno'),
    ('en_US', 'Sacramento'), ('en_US', 'Kansas City'), ('en_US', 'Atlanta'), ('en_US', 'Miami'),
    ('en_US', 'Omaha'), ('en_US', 'Colorado Springs'), ('en_US', 'Raleigh'), ('en_US', 'Minneapolis'),
    -- German cities
    ('de_DE', 'Berlin'), ('de_DE', 'Hamburg'), ('de_DE', 'München'), ('de_DE', 'Köln'),
    ('de_DE', 'Frankfurt'), ('de_DE', 'Stuttgart'), ('de_DE', 'Düsseldorf'), ('de_DE', 'Leipzig'),
    ('de_DE', 'Dortmund'), ('de_DE', 'Essen'), ('de_DE', 'Bremen'), ('de_DE', 'Dresden'),
    ('de_DE', 'Hannover'), ('de_DE', 'Nürnberg'), ('de_DE', 'Duisburg'), ('de_DE', 'Bochum'),
    ('de_DE', 'Wuppertal'), ('de_DE', 'Bielefeld'), ('de_DE', 'Bonn'), ('de_DE', 'Münster'),
    ('de_DE', 'Mannheim'), ('de_DE', 'Karlsruhe'), ('de_DE', 'Augsburg'), ('de_DE', 'Wiesbaden'),
    ('de_DE', 'Mönchengladbach'), ('de_DE', 'Gelsenkirchen'), ('de_DE', 'Aachen'), ('de_DE', 'Braunschweig'),
    ('de_DE', 'Kiel'), ('de_DE', 'Chemnitz'), ('de_DE', 'Halle'), ('de_DE', 'Magdeburg'),
    ('de_DE', 'Freiburg'), ('de_DE', 'Krefeld'), ('de_DE', 'Mainz'), ('de_DE', 'Lübeck'),
    ('de_DE', 'Erfurt'), ('de_DE', 'Rostock'), ('de_DE', 'Kassel'), ('de_DE', 'Oberhausen');

-- ============================================================================
-- STATES
-- ============================================================================
INSERT INTO faker.states (locale, name, abbreviation) VALUES
    -- US States
    ('en_US', 'Alabama', 'AL'), ('en_US', 'Alaska', 'AK'), ('en_US', 'Arizona', 'AZ'),
    ('en_US', 'Arkansas', 'AR'), ('en_US', 'California', 'CA'), ('en_US', 'Colorado', 'CO'),
    ('en_US', 'Connecticut', 'CT'), ('en_US', 'Delaware', 'DE'), ('en_US', 'Florida', 'FL'),
    ('en_US', 'Georgia', 'GA'), ('en_US', 'Hawaii', 'HI'), ('en_US', 'Idaho', 'ID'),
    ('en_US', 'Illinois', 'IL'), ('en_US', 'Indiana', 'IN'), ('en_US', 'Iowa', 'IA'),
    ('en_US', 'Kansas', 'KS'), ('en_US', 'Kentucky', 'KY'), ('en_US', 'Louisiana', 'LA'),
    ('en_US', 'Maine', 'ME'), ('en_US', 'Maryland', 'MD'), ('en_US', 'Massachusetts', 'MA'),
    ('en_US', 'Michigan', 'MI'), ('en_US', 'Minnesota', 'MN'), ('en_US', 'Mississippi', 'MS'),
    ('en_US', 'Missouri', 'MO'), ('en_US', 'Montana', 'MT'), ('en_US', 'Nebraska', 'NE'),
    ('en_US', 'Nevada', 'NV'), ('en_US', 'New Hampshire', 'NH'), ('en_US', 'New Jersey', 'NJ'),
    ('en_US', 'New Mexico', 'NM'), ('en_US', 'New York', 'NY'), ('en_US', 'North Carolina', 'NC'),
    ('en_US', 'North Dakota', 'ND'), ('en_US', 'Ohio', 'OH'), ('en_US', 'Oklahoma', 'OK'),
    ('en_US', 'Oregon', 'OR'), ('en_US', 'Pennsylvania', 'PA'), ('en_US', 'Rhode Island', 'RI'),
    ('en_US', 'South Carolina', 'SC'), ('en_US', 'South Dakota', 'SD'), ('en_US', 'Tennessee', 'TN'),
    ('en_US', 'Texas', 'TX'), ('en_US', 'Utah', 'UT'), ('en_US', 'Vermont', 'VT'),
    ('en_US', 'Virginia', 'VA'), ('en_US', 'Washington', 'WA'), ('en_US', 'West Virginia', 'WV'),
    ('en_US', 'Wisconsin', 'WI'), ('en_US', 'Wyoming', 'WY'),
    -- German States
    ('de_DE', 'Baden-Württemberg', 'BW'), ('de_DE', 'Bayern', 'BY'), ('de_DE', 'Berlin', 'BE'),
    ('de_DE', 'Brandenburg', 'BB'), ('de_DE', 'Bremen', 'HB'), ('de_DE', 'Hamburg', 'HH'),
    ('de_DE', 'Hessen', 'HE'), ('de_DE', 'Mecklenburg-Vorpommern', 'MV'),
    ('de_DE', 'Niedersachsen', 'NI'), ('de_DE', 'Nordrhein-Westfalen', 'NW'),
    ('de_DE', 'Rheinland-Pfalz', 'RP'), ('de_DE', 'Saarland', 'SL'),
    ('de_DE', 'Sachsen', 'SN'), ('de_DE', 'Sachsen-Anhalt', 'ST'),
    ('de_DE', 'Schleswig-Holstein', 'SH'), ('de_DE', 'Thüringen', 'TH');

-- ============================================================================
-- POSTAL CODE FORMATS
-- ============================================================================
INSERT INTO faker.postal_formats (locale, format) VALUES
    ('en_US', '#####'),
    ('en_US', '#####-####'),
    ('de_DE', '#####');

-- ============================================================================
-- PHONE FORMATS
-- ============================================================================
INSERT INTO faker.phone_formats (locale, format) VALUES
    ('en_US', '(###) ###-####'),
    ('en_US', '###-###-####'),
    ('en_US', '+1 ### ### ####'),
    ('en_US', '1-###-###-####'),
    ('de_DE', '+49 ### #######'),
    ('de_DE', '0### #######'),
    ('de_DE', '+49 (0)### #######'),
    ('de_DE', '0###/#######');

-- ============================================================================
-- EMAIL DOMAINS
-- ============================================================================
INSERT INTO faker.email_domains (locale, domain) VALUES
    ('en_US', 'gmail.com'), ('en_US', 'yahoo.com'), ('en_US', 'hotmail.com'),
    ('en_US', 'outlook.com'), ('en_US', 'aol.com'), ('en_US', 'icloud.com'),
    ('en_US', 'mail.com'), ('en_US', 'protonmail.com'), ('en_US', 'live.com'),
    ('de_DE', 'gmail.com'), ('de_DE', 'gmx.de'), ('de_DE', 'web.de'),
    ('de_DE', 't-online.de'), ('de_DE', 'freenet.de'), ('de_DE', 'yahoo.de'),
    ('de_DE', 'outlook.de'), ('de_DE', 'mail.de'), ('de_DE', 'posteo.de');

-- ============================================================================
-- EYE COLORS
-- ============================================================================
INSERT INTO faker.eye_colors (locale, color) VALUES
    ('en_US', 'Brown'), ('en_US', 'Blue'), ('en_US', 'Green'), ('en_US', 'Hazel'),
    ('en_US', 'Gray'), ('en_US', 'Amber'),
    ('de_DE', 'Braun'), ('de_DE', 'Blau'), ('de_DE', 'Grün'), ('de_DE', 'Haselnuss'),
    ('de_DE', 'Grau'), ('de_DE', 'Bernstein');

-- ============================================================================
-- ADDRESS FORMATS
-- ============================================================================
INSERT INTO faker.address_formats (locale, format) VALUES
    ('en_US', '{street_number} {street_name} {street_suffix}, {city}, {state} {postal}'),
    ('en_US', '{street_number} {street_name} {street_suffix}, Apt {apt}, {city}, {state} {postal}'),
    ('de_DE', '{street_name}{street_suffix} {street_number}, {postal} {city}'),
    ('de_DE', '{street_name}{street_suffix} {street_number}, {postal} {city}, {state}');
