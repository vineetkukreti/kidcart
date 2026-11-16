// ========== KidCart Frontend - Full Product Database ==========

const API_BASE = '/api/v1';

// Category emoji mapping
const categoryEmoji = {
    'stationery': '✏️', 'pens-pencils': '🖊️', 'notebooks-journals': '📓', 'art-supplies': '🎨', 'desk-organizers': '📎',
    'books': '📚', 'storybooks': '📖', 'textbooks': '📘', 'reference-books': '📕',
    'bags': '🎒', 'school-bags': '🎒', 'laptop-bags': '💼', 'lunch-bags': '🍱',
    'clothing': '👕', 'fashion': '👗', 'gifts': '🎁'
};

// Product emoji mapping by SKU prefix
const productEmoji = {
    'STN-PEN': '🖊️', 'STN-NB': '📓', 'STN-ART': '🎨', 'STN-DSK': '📎', 'STN-GEO': '📐',
    'STN-CAL': '🔢', 'STN-LBL': '🏷️', 'STN-WBD': '📋', 'STN-STK': '⭐',
    'BK-STR': '📖', 'BK-TXT': '📘', 'BK-REF': '📕',
    'BAG-SCH': '🎒', 'BAG-LAP': '💼', 'BAG-LUN': '🍱', 'BAG-TFN': '🍱', 'BAG-TOT': '👜',
    'CLT-UNI': '👔', 'CLT-TEE': '👕', 'CLT-HOD': '🧥', 'CLT-RCT': '🧥', 'CLT-TRK': '👖', 'CLT-JKT': '🧥', 'CLT-COS': '👸',
    'FSH-WCH': '⌚', 'FSH-SGL': '🕶️', 'FSH-BRC': '📿', 'FSH-WLT': '👛', 'FSH-HAR': '🎀', 'FSH-BTL': '🧴', 'FSH-YGA': '🧘',
    'GFT-STM': '🧩', 'GFT-SCI': '🔬', 'GFT-PLY': '🪁', 'GFT-SPK': '🔊', 'GFT-LMP': '💡', 'GFT-ARD': '🤖', 'GFT-CHR': '🪑',
    'GFT-ALF': '🔤', 'GFT-HPH': '🎧', 'GFT-BRD': '🎲', 'GFT-PZL': '🧩'
};

function getEmoji(sku) {
    if (!sku) return '📦';
    const prefix = sku.split('-').slice(0, 2).join('-');
    return productEmoji[prefix] || '📦';
}

const ageGroupNames = { 1: 'Toddler', 2: 'Child', 3: 'Tween', 4: 'Teen', 5: 'College' };
const ageGroupColors = {
    1: '#FFE5E5', 2: '#FFF8DC', 3: '#E8E0FF', 4: '#FFE0F0', 5: '#DCFCE7'
};

// ========== ALL 60 PRODUCTS (from database) ==========
const allProducts = [
    { id: '20000000-0000-0000-0000-000000000001', name: 'Rainbow Gel Pen Set (12 Colors)', slug: 'rainbow-gel-pen-set-12', category: 'Stationery', categorySlug: 'stationery', price: 249, originalPrice: 399, brand: 'Flair', sku: 'STN-PEN-001', ageGroup: 2, rating: 4.7, reviews: 234, isFeatured: true, desc: 'Vibrant 12-color gel pen set for creative kids' },
    { id: '20000000-0000-0000-0000-000000000002', name: 'Mechanical Pencil Pro Set', slug: 'mechanical-pencil-pro-set', category: 'Stationery', categorySlug: 'stationery', price: 449, originalPrice: 599, brand: 'Staedtler', sku: 'STN-PEN-002', ageGroup: 5, rating: 4.8, reviews: 189, isFeatured: false, desc: 'Professional mechanical pencil set for college' },
    { id: '20000000-0000-0000-0000-000000000003', name: 'Jumbo Triangular Crayons (24 Pack)', slug: 'jumbo-triangular-crayons-24', category: 'Stationery', categorySlug: 'stationery', price: 199, originalPrice: null, brand: 'Crayola', sku: 'STN-PEN-003', ageGroup: 1, rating: 4.9, reviews: 312, isFeatured: true, desc: 'Thick easy-grip crayons for little artists' },
    { id: '20000000-0000-0000-0000-000000000004', name: 'Calligraphy Brush Pen Set', slug: 'calligraphy-brush-pen-set', category: 'Stationery', categorySlug: 'stationery', price: 599, originalPrice: 799, brand: 'Tombow', sku: 'STN-PEN-004', ageGroup: 4, rating: 4.6, reviews: 98, isFeatured: false, desc: 'Flexible brush pens for lettering and art' },
    { id: '20000000-0000-0000-0000-000000000005', name: 'Sparkle Glitter Pens (8 Pack)', slug: 'sparkle-glitter-pens-8', category: 'Stationery', categorySlug: 'stationery', price: 179, originalPrice: 249, brand: 'Flair', sku: 'STN-PEN-005', ageGroup: 2, rating: 4.5, reviews: 156, isFeatured: false, desc: 'Glittery gel pens that make writing fun' },
    { id: '20000000-0000-0000-0000-000000000006', name: 'Campus A4 Notebook 5-Subject (300 Pages)', slug: 'campus-a4-notebook-5-subject', category: 'Stationery', categorySlug: 'stationery', price: 349, originalPrice: 449, brand: 'Classmate', sku: 'STN-NB-001', ageGroup: 5, rating: 4.6, reviews: 445, isFeatured: true, desc: 'Multi-subject notebook for organized notes' },
    { id: '20000000-0000-0000-0000-000000000007', name: 'Unicorn Diary with Lock', slug: 'unicorn-diary-with-lock', category: 'Stationery', categorySlug: 'stationery', price: 399, originalPrice: null, brand: 'Smiggle', sku: 'STN-NB-002', ageGroup: 2, rating: 4.8, reviews: 267, isFeatured: true, desc: 'Secret diary with lock for young dreamers' },
    { id: '20000000-0000-0000-0000-000000000008', name: 'Dot Grid Bullet Journal (A5)', slug: 'dot-grid-bullet-journal-a5', category: 'Stationery', categorySlug: 'stationery', price: 549, originalPrice: 699, brand: 'Archer & Olive', sku: 'STN-NB-003', ageGroup: 4, rating: 4.9, reviews: 178, isFeatured: false, desc: 'Premium dot grid journal for creative planning' },
    { id: '20000000-0000-0000-0000-000000000009', name: 'My First Writing Notebook (Set of 3)', slug: 'my-first-writing-notebook-set', category: 'Stationery', categorySlug: 'stationery', price: 149, originalPrice: null, brand: 'Navneet', sku: 'STN-NB-004', ageGroup: 1, rating: 4.4, reviews: 89, isFeatured: false, desc: 'Handwriting practice notebooks for beginners' },
    { id: '20000000-0000-0000-0000-000000000010', name: 'Aesthetic Pastel Notebook Set (4 Pack)', slug: 'aesthetic-pastel-notebook-set', category: 'Stationery', categorySlug: 'stationery', price: 449, originalPrice: 599, brand: 'Doodle Collection', sku: 'STN-NB-005', ageGroup: 3, rating: 4.7, reviews: 201, isFeatured: true, desc: 'Trendy pastel notebooks for the aesthetic lover' },
    { id: '20000000-0000-0000-0000-000000000011', name: 'Watercolor Paint Set (36 Colors)', slug: 'watercolor-paint-set-36', category: 'Stationery', categorySlug: 'stationery', price: 899, originalPrice: 1299, brand: 'Camel', sku: 'STN-ART-001', ageGroup: 3, rating: 4.8, reviews: 145, isFeatured: true, desc: 'Complete watercolor kit for young artists' },
    { id: '20000000-0000-0000-0000-000000000012', name: 'Finger Paint Set (6 Colors, Washable)', slug: 'finger-paint-set-washable', category: 'Stationery', categorySlug: 'stationery', price: 249, originalPrice: null, brand: 'Crayola', sku: 'STN-ART-002', ageGroup: 1, rating: 4.6, reviews: 198, isFeatured: false, desc: 'Safe washable paints for messy fun' },
    { id: '20000000-0000-0000-0000-000000000013', name: 'Sketching Pencil Kit (Professional)', slug: 'sketching-pencil-kit-pro', category: 'Stationery', categorySlug: 'stationery', price: 699, originalPrice: 999, brand: 'Faber-Castell', sku: 'STN-ART-003', ageGroup: 5, rating: 4.9, reviews: 112, isFeatured: false, desc: 'Professional sketching kit for art students' },
    { id: '20000000-0000-0000-0000-000000000014', name: 'The Magic Treehouse Collection (Books 1-8)', slug: 'magic-treehouse-collection-1-8', category: 'Books', categorySlug: 'books', price: 1299, originalPrice: 1599, brand: 'Scholastic', sku: 'BK-STR-001', ageGroup: 2, rating: 4.9, reviews: 567, isFeatured: true, desc: 'Bestselling adventure series box set' },
    { id: '20000000-0000-0000-0000-000000000015', name: 'Peppa Pig: My First Library (12 Board Books)', slug: 'peppa-pig-first-library', category: 'Books', categorySlug: 'books', price: 599, originalPrice: 799, brand: 'Penguin', sku: 'BK-STR-002', ageGroup: 1, rating: 4.8, reviews: 423, isFeatured: true, desc: 'Board book set for Peppa-loving toddlers' },
    { id: '20000000-0000-0000-0000-000000000016', name: 'Harry Potter Complete Collection (7 Books)', slug: 'harry-potter-complete-collection', category: 'Books', categorySlug: 'books', price: 2499, originalPrice: 3499, brand: 'Bloomsbury', sku: 'BK-STR-003', ageGroup: 3, rating: 5.0, reviews: 892, isFeatured: true, desc: 'Complete Harry Potter series box set' },
    { id: '20000000-0000-0000-0000-000000000017', name: 'NCERT Mathematics Class 10', slug: 'ncert-mathematics-class-10', category: 'Books', categorySlug: 'books', price: 199, originalPrice: null, brand: 'NCERT', sku: 'BK-TXT-001', ageGroup: 3, rating: 4.3, reviews: 156, isFeatured: false, desc: 'Official NCERT Math textbook for Class 10' },
    { id: '20000000-0000-0000-0000-000000000018', name: 'Atomic Habits by James Clear', slug: 'atomic-habits-james-clear', category: 'Books', categorySlug: 'books', price: 399, originalPrice: 599, brand: 'Penguin', sku: 'BK-REF-001', ageGroup: 5, rating: 4.9, reviews: 1234, isFeatured: true, desc: 'Life-changing guide to building better habits' },
    { id: '20000000-0000-0000-0000-000000000019', name: 'The Diary of a Wimpy Kid (Book 1)', slug: 'diary-wimpy-kid-1', category: 'Books', categorySlug: 'books', price: 299, originalPrice: 399, brand: 'Puffin', sku: 'BK-STR-004', ageGroup: 3, rating: 4.7, reviews: 678, isFeatured: false, desc: 'Hilarious illustrated diary for tweens' },
    { id: '20000000-0000-0000-0000-000000000020', name: 'The Subtle Art of Not Giving a F*ck', slug: 'subtle-art-mark-manson', category: 'Books', categorySlug: 'books', price: 349, originalPrice: 499, brand: 'HarperCollins', sku: 'BK-REF-002', ageGroup: 5, rating: 4.5, reviews: 567, isFeatured: false, desc: 'Brutally honest guide for college life' },
    { id: '20000000-0000-0000-0000-000000000021', name: 'Dinosaur Adventure Backpack', slug: 'dinosaur-adventure-backpack', category: 'Bags', categorySlug: 'bags', price: 899, originalPrice: 1199, brand: 'Wildcraft Kids', sku: 'BAG-SCH-001', ageGroup: 1, rating: 4.7, reviews: 234, isFeatured: true, desc: 'Fun 3D dinosaur bag for little explorers' },
    { id: '20000000-0000-0000-0000-000000000022', name: 'Urban Slim Laptop Backpack (15.6")', slug: 'urban-slim-laptop-backpack', category: 'Bags', categorySlug: 'bags', price: 1799, originalPrice: 2499, brand: 'American Tourister', sku: 'BAG-LAP-001', ageGroup: 5, rating: 4.8, reviews: 345, isFeatured: true, desc: 'Modern laptop bag for college students' },
    { id: '20000000-0000-0000-0000-000000000023', name: 'Floral Canvas School Bag', slug: 'floral-canvas-school-bag', category: 'Bags', categorySlug: 'bags', price: 1299, originalPrice: 1599, brand: 'Lavie', sku: 'BAG-SCH-002', ageGroup: 3, rating: 4.6, reviews: 189, isFeatured: false, desc: 'Pretty floral backpack for school girls' },
    { id: '20000000-0000-0000-0000-000000000024', name: 'Superhero Insulated Lunch Bag', slug: 'superhero-insulated-lunch-bag', category: 'Bags', categorySlug: 'bags', price: 449, originalPrice: 599, brand: 'Marvel', sku: 'BAG-LUN-001', ageGroup: 2, rating: 4.5, reviews: 167, isFeatured: false, desc: 'Cool superhero lunch bag for kids' },
    { id: '20000000-0000-0000-0000-000000000025', name: 'Sporty Sling Bag with Earphone Hole', slug: 'sporty-sling-bag-earphone', category: 'Bags', categorySlug: 'bags', price: 699, originalPrice: 899, brand: 'Skybags', sku: 'BAG-SCH-003', ageGroup: 4, rating: 4.4, reviews: 123, isFeatured: false, desc: 'Compact crossbody bag for active teens' },
    { id: '20000000-0000-0000-0000-000000000026', name: 'Cotton School Uniform Set', slug: 'cotton-school-uniform-set', category: 'Clothing', categorySlug: 'clothing', price: 799, originalPrice: 999, brand: 'Gini & Jony', sku: 'CLT-UNI-001', ageGroup: 2, rating: 4.3, reviews: 234, isFeatured: false, desc: 'Comfortable cotton uniform set for school' },
    { id: '20000000-0000-0000-0000-000000000027', name: 'Graphic Tee - "Code Like a Girl"', slug: 'graphic-tee-code-like-girl', category: 'Clothing', categorySlug: 'clothing', price: 499, originalPrice: null, brand: 'The Souled Store', sku: 'CLT-TEE-001', ageGroup: 4, rating: 4.8, reviews: 156, isFeatured: true, desc: 'Empowering graphic tee for tech teens' },
    { id: '20000000-0000-0000-0000-000000000028', name: 'College Hoodie - Classic Fit', slug: 'college-hoodie-classic-fit', category: 'Clothing', categorySlug: 'clothing', price: 1299, originalPrice: 1799, brand: 'H&M', sku: 'CLT-HOD-001', ageGroup: 5, rating: 4.7, reviews: 289, isFeatured: true, desc: 'Cozy oversized hoodie for campus life' },
    { id: '20000000-0000-0000-0000-000000000029', name: 'Raincoat with Fun Print (Waterproof)', slug: 'raincoat-fun-print-waterproof', category: 'Clothing', categorySlug: 'clothing', price: 649, originalPrice: 899, brand: 'Hopscotch', sku: 'CLT-RCT-001', ageGroup: 1, rating: 4.5, reviews: 87, isFeatured: false, desc: 'Cute waterproof raincoat for rainy days' },
    { id: '20000000-0000-0000-0000-000000000030', name: 'Track Pants - Slim Fit (Pack of 2)', slug: 'track-pants-slim-fit-2pk', category: 'Clothing', categorySlug: 'clothing', price: 899, originalPrice: 1199, brand: 'Allen Solly Junior', sku: 'CLT-TRK-001', ageGroup: 3, rating: 4.4, reviews: 145, isFeatured: false, desc: 'Comfortable track pants combo for active tweens' },
    { id: '20000000-0000-0000-0000-000000000031', name: 'Digital Sports Watch (Waterproof)', slug: 'digital-sports-watch-waterproof', category: 'Fashion', categorySlug: 'fashion', price: 799, originalPrice: 1199, brand: 'Casio', sku: 'FSH-WCH-001', ageGroup: 2, rating: 4.6, reviews: 234, isFeatured: true, desc: 'Rugged waterproof digital watch for kids' },
    { id: '20000000-0000-0000-0000-000000000032', name: 'Trendy Sunglasses - UV Protection', slug: 'trendy-sunglasses-uv-protection', category: 'Fashion', categorySlug: 'fashion', price: 599, originalPrice: 899, brand: 'Vincent Chase', sku: 'FSH-SGL-001', ageGroup: 4, rating: 4.5, reviews: 178, isFeatured: false, desc: 'Stylish UV-protected sunglasses for teens' },
    { id: '20000000-0000-0000-0000-000000000033', name: 'Friendship Bracelet Making Kit', slug: 'friendship-bracelet-making-kit', category: 'Fashion', categorySlug: 'fashion', price: 499, originalPrice: null, brand: 'Craft-tastic', sku: 'FSH-BRC-001', ageGroup: 3, rating: 4.7, reviews: 145, isFeatured: false, desc: 'DIY bracelet kit for creative friends' },
    { id: '20000000-0000-0000-0000-000000000034', name: 'Minimalist Leather Wallet', slug: 'minimalist-leather-wallet', category: 'Fashion', categorySlug: 'fashion', price: 899, originalPrice: 1299, brand: 'Fossil', sku: 'FSH-WLT-001', ageGroup: 5, rating: 4.8, reviews: 167, isFeatured: false, desc: 'Premium leather wallet for college students' },
    { id: '20000000-0000-0000-0000-000000000035', name: 'Princess Hair Accessories Box (50 pcs)', slug: 'princess-hair-accessories-box', category: 'Fashion', categorySlug: 'fashion', price: 349, originalPrice: 499, brand: "Li'l Diva", sku: 'FSH-HAR-001', ageGroup: 1, rating: 4.4, reviews: 198, isFeatured: false, desc: 'Complete hair accessory collection for girls' },
    { id: '20000000-0000-0000-0000-000000000036', name: 'STEM Building Blocks (150 pcs)', slug: 'stem-building-blocks-150', category: 'Gifts', categorySlug: 'gifts', price: 1499, originalPrice: 1999, brand: 'Lego Education', sku: 'GFT-STM-001', ageGroup: 2, rating: 4.9, reviews: 345, isFeatured: true, desc: 'Educational building blocks for future engineers' },
    { id: '20000000-0000-0000-0000-000000000037', name: 'Coding Robot - Learn to Program', slug: 'coding-robot-learn-program', category: 'Gifts', categorySlug: 'gifts', price: 2999, originalPrice: 3999, brand: 'Sphero', sku: 'GFT-STM-002', ageGroup: 3, rating: 4.8, reviews: 167, isFeatured: true, desc: 'Fun coding robot for young programmers' },
    { id: '20000000-0000-0000-0000-000000000038', name: 'Wooden Puzzle Set (6 Puzzles)', slug: 'wooden-puzzle-set-6', category: 'Gifts', categorySlug: 'gifts', price: 699, originalPrice: 899, brand: 'Melissa & Doug', sku: 'GFT-PZL-001', ageGroup: 1, rating: 4.7, reviews: 234, isFeatured: false, desc: 'Chunky wooden puzzles for toddler development' },
    { id: '20000000-0000-0000-0000-000000000039', name: 'Science Experiment Kit (50 Experiments)', slug: 'science-experiment-kit-50', category: 'Gifts', categorySlug: 'gifts', price: 1299, originalPrice: 1699, brand: 'National Geographic', sku: 'GFT-SCI-001', ageGroup: 3, rating: 4.6, reviews: 189, isFeatured: false, desc: '50 hands-on science experiments in a box' },
    { id: '20000000-0000-0000-0000-000000000040', name: 'Wireless Bluetooth Speaker (Mini)', slug: 'wireless-bluetooth-speaker-mini', category: 'Gifts', categorySlug: 'gifts', price: 1499, originalPrice: 1999, brand: 'JBL', sku: 'GFT-SPK-001', ageGroup: 5, rating: 4.8, reviews: 456, isFeatured: true, desc: 'Portable speaker for music-loving students' },
    { id: '20000000-0000-0000-0000-000000000041', name: 'Desk Organizer - Bamboo (Multi-slot)', slug: 'desk-organizer-bamboo', category: 'Stationery', categorySlug: 'stationery', price: 799, originalPrice: 999, brand: 'House of Quirk', sku: 'STN-DSK-001', ageGroup: 5, rating: 4.5, reviews: 89, isFeatured: false, desc: 'Eco-friendly bamboo desk organizer' },
    { id: '20000000-0000-0000-0000-000000000042', name: 'Magnetic Geometry Box', slug: 'magnetic-geometry-box', category: 'Stationery', categorySlug: 'stationery', price: 349, originalPrice: 499, brand: 'Faber-Castell', sku: 'STN-GEO-001', ageGroup: 3, rating: 4.6, reviews: 267, isFeatured: false, desc: 'Complete geometry set in magnetic case' },
    { id: '20000000-0000-0000-0000-000000000043', name: 'Motivational Quote Water Bottle (750ml)', slug: 'motivational-quote-water-bottle', category: 'Fashion', categorySlug: 'fashion', price: 449, originalPrice: 599, brand: 'Cello', sku: 'FSH-BTL-001', ageGroup: 4, rating: 4.4, reviews: 178, isFeatured: false, desc: 'Motivational water bottle for students' },
    { id: '20000000-0000-0000-0000-000000000044', name: 'LED Desk Lamp (Dimmable, USB)', slug: 'led-desk-lamp-dimmable-usb', category: 'Gifts', categorySlug: 'gifts', price: 899, originalPrice: 1299, brand: 'Syska', sku: 'GFT-LMP-001', ageGroup: 5, rating: 4.7, reviews: 234, isFeatured: false, desc: 'Adjustable LED study lamp with USB' },
    { id: '20000000-0000-0000-0000-000000000045', name: 'Play-Doh Mega Pack (36 Cans)', slug: 'play-doh-mega-pack-36', category: 'Gifts', categorySlug: 'gifts', price: 999, originalPrice: 1499, brand: 'Hasbro', sku: 'GFT-PLY-001', ageGroup: 1, rating: 4.6, reviews: 345, isFeatured: false, desc: 'Mega pack of Play-Doh in 36 colors' },
    { id: '20000000-0000-0000-0000-000000000046', name: 'Personalized Name Labels (100 pcs)', slug: 'personalized-name-labels-100', category: 'Stationery', categorySlug: 'stationery', price: 299, originalPrice: null, brand: 'Stuck On You', sku: 'STN-LBL-001', ageGroup: 2, rating: 4.5, reviews: 123, isFeatured: false, desc: 'Custom waterproof labels for school stuff' },
    { id: '20000000-0000-0000-0000-000000000047', name: 'Arduino Starter Kit for Beginners', slug: 'arduino-starter-kit-beginners', category: 'Gifts', categorySlug: 'gifts', price: 2499, originalPrice: 2999, brand: 'Arduino', sku: 'GFT-ARD-001', ageGroup: 4, rating: 4.9, reviews: 89, isFeatured: true, desc: 'Complete Arduino kit for teen makers' },
    { id: '20000000-0000-0000-0000-000000000048', name: 'Ergonomic Study Chair (Adjustable)', slug: 'ergonomic-study-chair-adjustable', category: 'Gifts', categorySlug: 'gifts', price: 4999, originalPrice: 6999, brand: 'Green Soul', sku: 'GFT-CHR-001', ageGroup: 3, rating: 4.6, reviews: 156, isFeatured: false, desc: 'Adjustable ergonomic chair for students' },
    { id: '20000000-0000-0000-0000-000000000049', name: 'Tiffin Box Set (Stainless Steel, 3 tier)', slug: 'tiffin-box-set-stainless-3tier', category: 'Bags', categorySlug: 'bags', price: 699, originalPrice: 899, brand: 'Milton', sku: 'BAG-TFN-001', ageGroup: 2, rating: 4.5, reviews: 234, isFeatured: false, desc: 'Insulated stainless steel lunch box set' },
    { id: '20000000-0000-0000-0000-000000000050', name: 'Scientific Calculator (FX-991EX)', slug: 'scientific-calculator-fx991ex', category: 'Stationery', categorySlug: 'stationery', price: 1299, originalPrice: 1499, brand: 'Casio', sku: 'STN-CAL-001', ageGroup: 5, rating: 4.8, reviews: 567, isFeatured: false, desc: 'Advanced scientific calculator for students' },
    { id: '20000000-0000-0000-0000-000000000051', name: 'Comic Drawing Kit with Lightbox', slug: 'comic-drawing-kit-lightbox', category: 'Stationery', categorySlug: 'stationery', price: 1799, originalPrice: 2299, brand: 'Copic', sku: 'STN-ART-004', ageGroup: 4, rating: 4.7, reviews: 78, isFeatured: false, desc: 'Complete comic art kit with LED lightbox' },
    { id: '20000000-0000-0000-0000-000000000052', name: 'Warm Winter Jacket - Puffer Style', slug: 'warm-winter-jacket-puffer', category: 'Clothing', categorySlug: 'clothing', price: 1999, originalPrice: 2999, brand: 'Decathlon', sku: 'CLT-JKT-001', ageGroup: 5, rating: 4.7, reviews: 198, isFeatured: true, desc: 'Packable puffer jacket for chilly campus days' },
    { id: '20000000-0000-0000-0000-000000000053', name: 'Magnetic Alphabet Learning Set', slug: 'magnetic-alphabet-learning-set', category: 'Gifts', categorySlug: 'gifts', price: 399, originalPrice: 549, brand: 'LeapFrog', sku: 'GFT-ALF-001', ageGroup: 1, rating: 4.6, reviews: 189, isFeatured: false, desc: 'Magnetic letters for learning ABCs' },
    { id: '20000000-0000-0000-0000-000000000054', name: 'Noise Cancelling Headphones (Student)', slug: 'noise-cancelling-headphones-student', category: 'Gifts', categorySlug: 'gifts', price: 2499, originalPrice: 3499, brand: 'Sony', sku: 'GFT-HPH-001', ageGroup: 5, rating: 4.8, reviews: 345, isFeatured: true, desc: 'ANC headphones for focused studying' },
    { id: '20000000-0000-0000-0000-000000000055', name: 'Fairy Tale Dress-Up Costume Set', slug: 'fairy-tale-dress-up-costume-set', category: 'Clothing', categorySlug: 'clothing', price: 1299, originalPrice: 1799, brand: 'Disney', sku: 'CLT-COS-001', ageGroup: 1, rating: 4.7, reviews: 123, isFeatured: false, desc: 'Magical dress-up set for imaginative play' },
    { id: '20000000-0000-0000-0000-000000000056', name: 'Trendy Canvas Tote Bag', slug: 'trendy-canvas-tote-bag', category: 'Bags', categorySlug: 'bags', price: 599, originalPrice: 799, brand: 'Chumbak', sku: 'BAG-TOT-001', ageGroup: 5, rating: 4.5, reviews: 167, isFeatured: false, desc: 'Aesthetic canvas tote for campus style' },
    { id: '20000000-0000-0000-0000-000000000057', name: 'Board Games Family Pack (4 Games)', slug: 'board-games-family-pack-4', category: 'Gifts', categorySlug: 'gifts', price: 1999, originalPrice: 2799, brand: 'Hasbro', sku: 'GFT-BRD-001', ageGroup: 2, rating: 4.8, reviews: 234, isFeatured: false, desc: '4 classic board games for family fun' },
    { id: '20000000-0000-0000-0000-000000000058', name: 'Portable Whiteboard (A3, Double-sided)', slug: 'portable-whiteboard-a3-double', category: 'Stationery', categorySlug: 'stationery', price: 449, originalPrice: 599, brand: 'Writey', sku: 'STN-WBD-001', ageGroup: 3, rating: 4.4, reviews: 98, isFeatured: false, desc: 'Portable whiteboard for study sessions' },
    { id: '20000000-0000-0000-0000-000000000059', name: 'Yoga Mat for Kids (with Poses Print)', slug: 'yoga-mat-kids-poses-print', category: 'Fashion', categorySlug: 'fashion', price: 599, originalPrice: 799, brand: 'Boldfit', sku: 'FSH-YGA-001', ageGroup: 2, rating: 4.5, reviews: 67, isFeatured: false, desc: 'Fun yoga mat with printed poses for kids' },
    { id: '20000000-0000-0000-0000-000000000060', name: 'Aesthetic Sticker Collection (500 pcs)', slug: 'aesthetic-sticker-collection-500', category: 'Stationery', categorySlug: 'stationery', price: 299, originalPrice: 449, brand: 'StickerBomb', sku: 'STN-STK-001', ageGroup: 4, rating: 4.6, reviews: 456, isFeatured: true, desc: 'Massive sticker pack for personalizing everything' },
];

// ========== STATE ==========
let cart = JSON.parse(localStorage.getItem('kidcart_cart') || '[]');
let wishlist = JSON.parse(localStorage.getItem('kidcart_wishlist') || '[]');
let currentFilter = { category: null, ageGroup: null, search: '' };

// ========== HELPER FUNCTIONS ==========
function getDiscount(price, original) {
    if (!original || original <= price) return null;
    return Math.round(((original - price) / original) * 100);
}

function getStars(rating) {
    const full = Math.floor(rating);
    const half = rating % 1 >= 0.5 ? 1 : 0;
    return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(5 - full - half);
}

function getBadge(product) {
    const discount = getDiscount(product.price, product.originalPrice);
    if (discount && discount >= 25) return { text: `${discount}% OFF`, class: 'badge-sale' };
    if (product.isFeatured) return { text: 'HOT', class: 'badge-hot' };
    return { text: 'NEW', class: 'badge-new-tag' };
}

// ========== RENDER ==========
function renderProductCard(product) {
    const badge = getBadge(product);
    const discount = getDiscount(product.price, product.originalPrice);
    const emoji = getEmoji(product.sku);
    const bgColor = ageGroupColors[product.ageGroup] || '#f0f0f0';
    const isWished = wishlist.includes(product.id);

    return `
        <div class="product-card" data-id="${product.id}" data-age="${product.ageGroup}" data-category="${product.categorySlug}" onclick="openProductDetail('${product.id}')">
            <div class="product-image" style="background:${bgColor}">
                <span class="product-badge ${badge.class}">${badge.text}</span>
                <button class="product-wishlist" onclick="event.stopPropagation(); toggleWishlist('${product.id}', this)" style="${isWished ? 'color:var(--primary)' : ''}">${isWished ? '♥' : '♡'}</button>
                ${emoji}
            </div>
            <div class="product-info">
                <div class="product-category">${product.category} · ${ageGroupNames[product.ageGroup]}</div>
                <div class="product-name">${product.name}</div>
                <div class="product-rating">${getStars(product.rating)} <span>(${product.reviews.toLocaleString()})</span></div>
                <div class="product-price">
                    <span class="price-current">₹${product.price.toLocaleString()}</span>
                    ${product.originalPrice ? `<span class="price-original">₹${product.originalPrice.toLocaleString()}</span>` : ''}
                    ${discount ? `<span class="price-discount">${discount}% OFF</span>` : ''}
                </div>
                <button class="product-add" onclick="event.stopPropagation(); addToCart('${product.id}')">Add to Cart</button>
            </div>
        </div>`;
}

function renderProducts() {
    // Trending = featured products sorted by reviews
    const trending = allProducts.filter(p => p.isFeatured).sort((a, b) => b.reviews - a.reviews).slice(0, 4);
    document.getElementById('trendingGrid').innerHTML = trending.map(renderProductCard).join('');

    // New arrivals = most recently added (simulated by array end)
    const newArrivals = [...allProducts].sort((a, b) => b.reviews - a.reviews).slice(4, 8);
    document.getElementById('newArrivalsGrid').innerHTML = newArrivals.map(renderProductCard).join('');
}

// ========== PRODUCT DETAIL MODAL ==========
function openProductDetail(productId) {
    const product = allProducts.find(p => p.id === productId);
    if (!product) return;

    const discount = getDiscount(product.price, product.originalPrice);
    const emoji = getEmoji(product.sku);
    const isWished = wishlist.includes(product.id);

    const modal = document.createElement('div');
    modal.className = 'product-detail-overlay';
    modal.innerHTML = `
        <div class="product-detail-modal">
            <button class="close-btn" onclick="this.closest('.product-detail-overlay').remove()">✕</button>
            <div class="pd-layout">
                <div class="pd-image" style="background:${ageGroupColors[product.ageGroup]}">
                    <span style="font-size:120px">${emoji}</span>
                    <span class="product-badge ${getBadge(product).class}" style="position:absolute;top:20px;left:20px">${getBadge(product).text}</span>
                </div>
                <div class="pd-info">
                    <div class="product-category">${product.category} · ${product.brand}</div>
                    <h2 style="font-size:24px;margin:8px 0">${product.name}</h2>
                    <div class="product-rating" style="font-size:16px">${getStars(product.rating)} <span>(${product.reviews.toLocaleString()} reviews)</span></div>
                    <div style="display:flex;align-items:center;gap:12px;margin:16px 0">
                        <span style="font-size:28px;font-weight:800">₹${product.price.toLocaleString()}</span>
                        ${product.originalPrice ? `<span style="font-size:18px;color:#adb5bd;text-decoration:line-through">₹${product.originalPrice.toLocaleString()}</span>` : ''}
                        ${discount ? `<span style="background:#dcfce7;color:#22c55e;padding:4px 10px;border-radius:20px;font-size:13px;font-weight:600">Save ${discount}%</span>` : ''}
                    </div>
                    <div style="padding:12px;background:#f8f9fa;border-radius:10px;margin:12px 0">
                        <div style="font-size:12px;color:#6c757d;text-transform:uppercase;letter-spacing:1px;margin-bottom:4px">Age Group</div>
                        <div style="font-size:15px;font-weight:600">${ageGroupNames[product.ageGroup]} (${['', '3-5', '6-10', '11-13', '14-17', '18-22'][product.ageGroup]} years)</div>
                    </div>
                    <p style="color:#6c757d;line-height:1.7;margin:12px 0">${product.desc}</p>
                    <div style="display:flex;gap:10px;margin-top:20px">
                        <button class="btn btn-primary btn-lg" style="flex:1" onclick="addToCart('${product.id}'); this.closest('.product-detail-overlay').remove()">Add to Cart</button>
                        <button class="btn btn-outline" style="font-size:20px;padding:12px 16px" onclick="toggleWishlist('${product.id}', this)">${isWished ? '♥' : '♡'}</button>
                    </div>
                    <p style="text-align:center;font-size:12px;color:#adb5bd;margin-top:12px">🚚 Free delivery on orders above ₹499 · 🔄 Easy 7-day returns</p>
                </div>
            </div>
        </div>`;
    document.body.appendChild(modal);
    modal.addEventListener('click', (e) => { if (e.target === modal) modal.remove(); });
}

// ========== CART ==========
function addToCart(productId) {
    const product = allProducts.find(p => p.id === productId);
    if (!product) return;
    const existing = cart.find(item => item.id === productId);
    if (existing) { existing.qty++; } else { cart.push({ ...product, qty: 1 }); }
    saveCart();
    updateCartUI();
    showToast(`${product.name} added to cart!`);
}

function removeFromCart(productId) {
    cart = cart.filter(item => item.id !== productId);
    saveCart();
    updateCartUI();
}

function updateQty(productId, delta) {
    const item = cart.find(i => i.id === productId);
    if (!item) return;
    item.qty += delta;
    if (item.qty <= 0) { removeFromCart(productId); return; }
    saveCart();
    updateCartUI();
}

function saveCart() { localStorage.setItem('kidcart_cart', JSON.stringify(cart)); }

function updateCartUI() {
    const badge = document.getElementById('cartBadge');
    const cartItems = document.getElementById('cartItems');
    const cartFooter = document.getElementById('cartFooter');
    const cartTotal = document.getElementById('cartTotal');
    const totalItems = cart.reduce((sum, item) => sum + item.qty, 0);
    badge.textContent = totalItems;

    if (cart.length === 0) {
        cartItems.innerHTML = `<div class="empty-cart"><span class="empty-icon">🛒</span><p>Your cart is empty</p><button class="btn btn-primary" onclick="closeCart()">Start Shopping</button></div>`;
        cartFooter.style.display = 'none';
    } else {
        cartItems.innerHTML = cart.map(item => `
            <div class="cart-item-row">
                <div class="cart-item-img">${getEmoji(item.sku)}</div>
                <div class="cart-item-info">
                    <div class="cart-item-name">${item.name}</div>
                    <div class="cart-item-variant">${item.category} · ${item.brand || ''}</div>
                    <div class="cart-item-price">₹${(item.price * item.qty).toLocaleString()}</div>
                    <div class="cart-item-actions">
                        <button class="qty-btn" onclick="updateQty('${item.id}', -1)">−</button>
                        <span class="qty-value">${item.qty}</span>
                        <button class="qty-btn" onclick="updateQty('${item.id}', 1)">+</button>
                        <button class="cart-item-remove" onclick="removeFromCart('${item.id}')">🗑️</button>
                    </div>
                </div>
            </div>`).join('');
        const total = cart.reduce((sum, item) => sum + (item.price * item.qty), 0);
        cartTotal.textContent = `₹${total.toLocaleString()}`;
        cartFooter.style.display = 'block';
    }
}

function openCart() { document.getElementById('cartOverlay').classList.add('open'); document.getElementById('cartSidebar').classList.add('open'); document.body.style.overflow = 'hidden'; }
function closeCart() { document.getElementById('cartOverlay').classList.remove('open'); document.getElementById('cartSidebar').classList.remove('open'); document.body.style.overflow = ''; }

// ========== WISHLIST ==========
function toggleWishlist(productId, btn) {
    const idx = wishlist.indexOf(productId);
    if (idx === -1) { wishlist.push(productId); showToast('Added to wishlist ♥'); }
    else { wishlist.splice(idx, 1); showToast('Removed from wishlist'); }
    localStorage.setItem('kidcart_wishlist', JSON.stringify(wishlist));
    if (btn) { btn.textContent = idx === -1 ? '♥' : '♡'; btn.style.color = idx === -1 ? 'var(--primary)' : ''; }
}

// ========== AUTH MODAL ==========
function openAuth() { document.getElementById('authOverlay').classList.add('open'); document.getElementById('authModal').classList.add('open'); document.body.style.overflow = 'hidden'; }
function closeAuth() { document.getElementById('authOverlay').classList.remove('open'); document.getElementById('authModal').classList.remove('open'); document.body.style.overflow = ''; }
function switchTab(tab) {
    document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('active'));
    event.target.classList.add('active');
    document.getElementById('loginForm').style.display = tab === 'login' ? 'block' : 'none';
    document.getElementById('registerForm').style.display = tab === 'register' ? 'block' : 'none';
}

// ========== FILTERING ==========
function filterAge(age) {
    const ageMap = { toddler: 1, child: 2, tween: 3, teen: 4, college: 5 };
    const ageNum = ageMap[age];
    const filtered = allProducts.filter(p => p.ageGroup === ageNum);

    document.querySelectorAll('.age-card').forEach(c => { c.style.transform = ''; c.style.boxShadow = ''; });
    event.currentTarget.style.transform = 'translateY(-8px) scale(1.03)';
    event.currentTarget.style.boxShadow = '0 12px 40px rgba(0,0,0,0.15)';

    showFilteredResults(filtered, `${age.charAt(0).toUpperCase() + age.slice(1)} Products`, `Ages ${['', '3-5', '6-10', '11-13', '14-17', '18-22'][ageNum]}`);
}

function filterCategory(category) {
    const filtered = allProducts.filter(p => p.categorySlug === category || p.category.toLowerCase() === category);
    showFilteredResults(filtered, `${category.charAt(0).toUpperCase() + category.slice(1)}`, `${filtered.length} products`);

    document.querySelectorAll('.nav-cat-link').forEach(l => l.classList.remove('active'));
    event?.target?.classList?.add('active');
}

function showFilteredResults(products, title, subtitle) {
    // Remove any existing results section
    document.getElementById('filtered-results')?.remove();

    const section = document.createElement('section');
    section.id = 'filtered-results';
    section.className = 'section section-cream';
    section.style.paddingTop = '30px';
    section.innerHTML = `
        <div class="section-header">
            <div>
                <h2 class="section-title" style="text-align:left">${title}</h2>
                <p class="section-subtitle" style="text-align:left;margin-bottom:0">${subtitle} · ${products.length} items</p>
            </div>
            <button class="btn btn-outline btn-sm" onclick="clearFilter()">✕ Clear Filter</button>
        </div>
        <div class="product-grid" style="padding:0 24px">${products.map(renderProductCard).join('')}</div>`;

    const hero = document.querySelector('.hero');
    hero.parentNode.insertBefore(section, hero.nextSibling);
    section.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function clearFilter() {
    document.getElementById('filtered-results')?.remove();
    document.querySelectorAll('.age-card').forEach(c => { c.style.transform = ''; c.style.boxShadow = ''; });
    document.querySelectorAll('.nav-cat-link').forEach(l => l.classList.remove('active'));
    document.querySelector('.nav-cat-link').classList.add('active');
}

// ========== SEARCH ==========
let searchTimeout;
document.getElementById('searchInput')?.addEventListener('input', function(e) {
    clearTimeout(searchTimeout);
    const query = e.target.value.toLowerCase().trim();
    if (query.length < 2) { document.getElementById('filtered-results')?.remove(); return; }

    searchTimeout = setTimeout(() => {
        const results = allProducts.filter(p =>
            p.name.toLowerCase().includes(query) ||
            p.category.toLowerCase().includes(query) ||
            p.brand?.toLowerCase().includes(query) ||
            p.desc.toLowerCase().includes(query) ||
            ageGroupNames[p.ageGroup].toLowerCase().includes(query)
        );
        showFilteredResults(results, `Search: "${e.target.value}"`, `Found ${results.length} results`);
    }, 300);
});

// ========== SCROLL ==========
function scrollTo(selector) { document.querySelector(selector)?.scrollIntoView({ behavior: 'smooth', block: 'start' }); }

// ========== TOAST ==========
function showToast(message) {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 2500);
}

// ========== FORMS ==========
document.getElementById('loginForm')?.addEventListener('submit', function(e) { e.preventDefault(); showToast('Login successful! Welcome back.'); closeAuth(); });
document.getElementById('registerForm')?.addEventListener('submit', function(e) { e.preventDefault(); showToast('Account created! Welcome to KidCart.'); closeAuth(); });

// ========== INIT ==========
document.addEventListener('DOMContentLoaded', () => {
    renderProducts();
    updateCartUI();
});
