import 'package:flutter/material.dart';

class AgentPersona {
  final String id;
  final String name;
  final String role;
  final String division;
  final String emoji;
  final String description;
  final String vibe;
  final List<String> specialties;
  final List<String> sampleQuestions;
  final Color color;
  final IconData icon;
  final Map<String, String> responses;

  const AgentPersona({
    required this.id,
    required this.name,
    required this.role,
    required this.division,
    required this.emoji,
    required this.description,
    required this.vibe,
    required this.specialties,
    required this.sampleQuestions,
    required this.color,
    required this.icon,
    required this.responses,
  });
}

class AgentRegistry {
  static const List<AgentPersona> agents = [
    // ── GROWTH HACKER ──
    AgentPersona(
      id: 'growth-hacker',
      name: 'Maya',
      role: 'Growth Hacker',
      division: 'Marketing',
      emoji: '🚀',
      description:
          'Data-driven growth strategist who finds untapped channels and scales them fast. Obsessed with viral mechanics and funnel optimization.',
      vibe: 'Finds the growth channel nobody\'s exploited yet — then scales it.',
      specialties: [
        'Viral marketing campaigns',
        'Funnel optimization',
        'Referral program design',
        'Social media growth',
        'Customer acquisition',
      ],
      sampleQuestions: [
        'How do I get my first 1,000 customers?',
        'Design a referral program for Farm Fresh',
        'What social media strategy should I use?',
        'How to reduce customer acquisition cost?',
      ],
      color: Color(0xFFE91E63),
      icon: Icons.rocket_launch,
      responses: {
        'customer':
            'Here\'s your Farm Fresh growth playbook:\n\n'
            '1. **Referral Engine**: Give \$5 credit for every referral. Both sides get rewarded. Target: viral coefficient >1.0\n\n'
            '2. **Instagram-First Strategy**: Post farm-to-table stories daily. Behind-the-scenes content of farmers harvesting gets 3x engagement.\n\n'
            '3. **Neighborhood Launch**: Focus on one ZIP code. Saturate it with flyers at farmers markets + geo-targeted ads. 80% penetration before expanding.\n\n'
            '4. **First-Order Hook**: Free delivery + 20% off first order. Conversion rate jumps from 2% to 12%.\n\n'
            '5. **Weekly Box Subscription**: Curated seasonal produce box at \$29.99/week. Predictable revenue + 85% retention rate.\n\n'
            'Target: 20% MoM growth for first 6 months.',
        'referral':
            'Farm Fresh Referral Program Design:\n\n'
            '**Tier 1 - Share & Earn:**\n'
            '- Give \$5, Get \$5 for each referral\n'
            '- Unique referral link per customer\n\n'
            '**Tier 2 - Ambassador Program:**\n'
            '- 5+ referrals → 10% permanent discount\n'
            '- Monthly "Top Referrer" gets a free produce box\n\n'
            '**Tier 3 - Community Champion:**\n'
            '- 20+ referrals → Free weekly delivery for life\n'
            '- Featured on app as "Community Champion"\n\n'
            '**Viral Mechanics:**\n'
            '- Share button on every order confirmation\n'
            '- "Share your haul" photo feature with social integration\n'
            '- Seasonal referral bonuses (2x rewards in spring)\n\n'
            'Expected viral coefficient: 1.3 (each customer brings 1.3 new customers)',
        'social':
            'Social Media Growth Strategy:\n\n'
            '**Instagram (Primary - 60% effort):**\n'
            '- Daily Stories: Farm sunrise, harvest, packing orders\n'
            '- Reels: "Farm to fork in 60 seconds" recipe videos\n'
            '- UGC: Repost customer unboxing photos\n'
            '- Target: 10K followers in 90 days\n\n'
            '**TikTok (Secondary - 25% effort):**\n'
            '- "Day in the life of a farmer" series\n'
            '- Oddly satisfying harvest videos\n'
            '- Food prep with fresh ingredients\n\n'
            '**Facebook Groups (15% effort):**\n'
            '- Create "Farm Fresh Community" local group\n'
            '- Weekly recipe challenges\n'
            '- Farmer Q&A sessions\n\n'
            'Content calendar: 3 posts/day across platforms',
        'default':
            'I can help you with:\n\n'
            '- Customer acquisition strategies\n'
            '- Referral program design\n'
            '- Social media growth plans\n'
            '- Funnel optimization\n'
            '- Viral marketing campaigns\n\n'
            'What growth challenge are you facing?',
      },
    ),

    // ── SUPPLY CHAIN OPTIMIZER ──
    AgentPersona(
      id: 'supply-chain',
      name: 'Alex',
      role: 'Supply Chain Optimizer',
      division: 'Operations',
      emoji: '📦',
      description:
          'Logistics expert who minimizes waste, optimizes delivery routes, and ensures freshness from farm to doorstep.',
      vibe: 'Every minute saved in the chain is freshness preserved on the plate.',
      specialties: [
        'Route optimization',
        'Inventory forecasting',
        'Cold chain management',
        'Waste reduction',
        'Delivery scheduling',
      ],
      sampleQuestions: [
        'How do I reduce food waste?',
        'Optimize my delivery routes',
        'Best practices for cold chain?',
        'How to forecast inventory needs?',
      ],
      color: Color(0xFF2196F3),
      icon: Icons.local_shipping,
      responses: {
        'waste':
            'Food Waste Reduction Strategy:\n\n'
            '**1. Dynamic Pricing (saves 30% waste):**\n'
            '- Products within 2 days of peak freshness → 20% off\n'
            '- "Rescue Bags" of mixed near-expiry items → 50% off\n'
            '- AI alerts when stock approaches freshness threshold\n\n'
            '**2. Demand-Matched Harvesting:**\n'
            '- Only harvest what\'s pre-ordered + 15% buffer\n'
            '- Reduce over-supply waste from 25% to 5%\n\n'
            '**3. Composting Partnership:**\n'
            '- Partner with local composting facility\n'
            '- Unsold produce → compost → back to farms\n'
            '- Market as "Zero Waste Marketplace"\n\n'
            '**4. Shelf-Life Tracking:**\n'
            '- Tag each product with harvest date\n'
            '- FIFO automated in warehouse picking\n'
            '- Customer sees "Harvested X hours ago"\n\n'
            'Target: <3% total food waste rate.',
        'route':
            'Delivery Route Optimization:\n\n'
            '**Algorithm: Cluster-First, Route-Second**\n\n'
            '1. **Zone Clustering:**\n'
            '   - Divide delivery area into 1-mile zones\n'
            '   - Batch orders by zone + time window\n'
            '   - Max 8 deliveries per route\n\n'
            '2. **Time Windows:**\n'
            '   - Morning: 8AM-12PM (perishables priority)\n'
            '   - Afternoon: 12PM-5PM (standard)\n'
            '   - Evening: 5PM-8PM (premium \$2 surcharge)\n\n'
            '3. **Dynamic Rerouting:**\n'
            '   - Real-time traffic integration\n'
            '   - New orders inserted into active routes\n'
            '   - Driver app shows optimized sequence\n\n'
            '**Expected Results:**\n'
            '- 35% reduction in delivery time\n'
            '- 22% fuel savings\n'
            '- 40% more deliveries per driver shift',
        'default':
            'I can help optimize your supply chain:\n\n'
            '- Delivery route planning\n'
            '- Food waste reduction strategies\n'
            '- Cold chain best practices\n'
            '- Inventory forecasting\n'
            '- Warehouse layout optimization\n\n'
            'What logistics challenge can I solve?',
      },
    ),

    // ── CUSTOMER SUPPORT ──
    AgentPersona(
      id: 'support',
      name: 'Sam',
      role: 'Support Specialist',
      division: 'Support',
      emoji: '💬',
      description:
          'Empathetic support expert who resolves issues fast and turns complaints into loyalty. Multi-channel, solution-focused.',
      vibe: 'Every support interaction is a chance to create a customer for life.',
      specialties: [
        'Order issue resolution',
        'Refund & return handling',
        'Customer satisfaction',
        'FAQ management',
        'Complaint de-escalation',
      ],
      sampleQuestions: [
        'My order arrived damaged',
        'I want to cancel my order',
        'Wrong items were delivered',
        'How do returns work?',
      ],
      color: Color(0xFF00BCD4),
      icon: Icons.support_agent,
      responses: {
        'damaged':
            'I\'m sorry to hear about the damaged items! Here\'s what I\'ll do:\n\n'
            '**Immediate Resolution:**\n'
            '1. Full refund for damaged items processed within 24 hours\n'
            '2. Free replacement order shipped today (priority delivery)\n'
            '3. \$5 credit added to your account for the inconvenience\n\n'
            '**Quality Improvement:**\n'
            '- I\'ve flagged this to our packaging team\n'
            '- We\'re upgrading to insulated boxes for fragile produce\n'
            '- Your driver has been notified about handling guidelines\n\n'
            'No need to return the damaged items — please compost or donate what you can.\n\n'
            'Is there anything else I can help with? Your satisfaction is my priority.',
        'cancel':
            'I can help with your cancellation:\n\n'
            '**Order Status Check:**\n'
            '- If **not yet prepared** → Full refund, cancelled immediately\n'
            '- If **being prepared** → 90% refund (restocking)\n'
            '- If **out for delivery** → Please refuse delivery for full refund\n\n'
            '**Before you go:**\n'
            'Would you like to modify the order instead? I can:\n'
            '- Swap items you don\'t want\n'
            '- Change delivery time\n'
            '- Apply a 15% discount to keep the order\n\n'
            'We\'d love to make it right!',
        'wrong':
            'I apologize for the mix-up! Let me fix this right away:\n\n'
            '**Step 1:** Keep the items you received — they\'re yours, on us.\n'
            '**Step 2:** Correct items being dispatched now with priority delivery (free).\n'
            '**Step 3:** \$5 credit added to your account.\n\n'
            'I\'ve also flagged the order for our fulfillment team to investigate.\n\n'
            'Want me to double-check your current order details?',
        'default':
            'Hi there! I\'m Sam, your Farm Fresh support specialist.\n\n'
            'I can help with:\n'
            '- Order issues (damaged, wrong, missing items)\n'
            '- Cancellations and refunds\n'
            '- Delivery questions\n'
            '- Account help\n'
            '- General questions\n\n'
            'How can I help you today?',
      },
    ),

    // ── NUTRITION ADVISOR ──
    AgentPersona(
      id: 'nutrition',
      name: 'Dr. Nora',
      role: 'Nutrition Advisor',
      division: 'Health & Wellness',
      emoji: '🥗',
      description:
          'Certified nutrition expert who helps customers make healthy choices, plan meals, and understand the benefits of farm-fresh produce.',
      vibe: 'Food is medicine — and fresh, local food is the best prescription.',
      specialties: [
        'Meal planning',
        'Nutritional analysis',
        'Diet recommendations',
        'Seasonal eating guides',
        'Allergy-safe suggestions',
      ],
      sampleQuestions: [
        'Plan a week of healthy meals',
        'What are the healthiest items in stock?',
        'I\'m trying to eat more protein',
        'Suggest meals for my kids',
      ],
      color: Color(0xFF4CAF50),
      icon: Icons.local_dining,
      responses: {
        'meal':
            'Here\'s a 7-Day Farm Fresh Meal Plan:\n\n'
            '**Monday:** Spinach & goat cheese frittata (eggs + spinach + goat cheese)\n'
            '**Tuesday:** Grilled corn & tomato salad with basil dressing\n'
            '**Wednesday:** Grass-fed beef burgers with fresh tomato slices\n'
            '**Thursday:** Honey-glazed roasted vegetables medley\n'
            '**Friday:** Sourdough toast with blueberry jam & goat cheese\n'
            '**Saturday:** Strawberry spinach salad with honey vinaigrette\n'
            '**Sunday:** Farm breakfast — eggs, sourdough, tomatoes, basil\n\n'
            '**Shopping List (all from Farm Fresh):**\n'
            '- Eggs, spinach, tomatoes, basil, corn\n'
            '- Goat cheese, ground beef, sourdough\n'
            '- Strawberries, blueberries, honey\n\n'
            'Total estimated cost: \$45-55/week for 2 people',
        'healthy':
            'Top 5 Healthiest Items on Farm Fresh:\n\n'
            '1. **Baby Spinach** — Iron, Vitamin K, folate. 23 cal/cup\n'
            '   Best for: Smoothies, salads, sautéed sides\n\n'
            '2. **Organic Blueberries** — Antioxidant powerhouse\n'
            '   Best for: Breakfast bowls, snacking, smoothies\n\n'
            '3. **Farm Fresh Eggs** — Complete protein, B12, choline\n'
            '   Best for: Any meal! 6g protein per egg\n\n'
            '4. **Organic Tomatoes** — Lycopene, Vitamin C\n'
            '   Best for: Raw in salads, roasted, sauces\n\n'
            '5. **Raw Honey** — Natural antibacterial, antioxidants\n'
            '   Best for: Tea, yogurt topping, wound healing\n\n'
            'All organic, locally grown, and at peak nutrition!',
        'default':
            'Hello! I\'m Dr. Nora, your nutrition advisor.\n\n'
            'I can help with:\n'
            '- Weekly meal planning with farm-fresh ingredients\n'
            '- Nutritional analysis of products\n'
            '- Dietary recommendations (keto, vegan, paleo)\n'
            '- Seasonal eating guides\n'
            '- Kids-friendly meal ideas\n\n'
            'What would you like help with?',
      },
    ),

    // ── PRICING STRATEGIST ──
    AgentPersona(
      id: 'pricing',
      name: 'Victor',
      role: 'Pricing Strategist',
      division: 'Sales',
      emoji: '💰',
      description:
          'Revenue optimization expert who uses market data and competitive analysis to maximize margins while keeping customers happy.',
      vibe: 'The right price isn\'t the lowest — it\'s the one that tells your value story.',
      specialties: [
        'Dynamic pricing models',
        'Competitive analysis',
        'Bundle strategies',
        'Seasonal pricing',
        'Premium positioning',
      ],
      sampleQuestions: [
        'Am I pricing my products right?',
        'How to create product bundles?',
        'Should I raise prices on organic?',
        'What\'s the best discount strategy?',
      ],
      color: Color(0xFFFF9800),
      icon: Icons.price_change,
      responses: {
        'pricing':
            'Farm Fresh Pricing Analysis:\n\n'
            '**Your Current vs. Market:**\n'
            '| Product | You | Market Avg | Action |\n'
            '|---------|-----|-----------|--------|\n'
            '| Organic Tomatoes | \$4.99 | \$5.49 | Raise to \$5.29 |\n'
            '| Strawberries | \$6.49 | \$6.99 | Raise to \$6.79 |\n'
            '| Farm Eggs | \$5.99 | \$6.49 | Raise to \$6.29 |\n'
            '| Raw Honey | \$12.99 | \$14.99 | Raise to \$13.99 |\n\n'
            '**Revenue Impact:** +\$2.40/order average → +18% monthly revenue\n\n'
            '**Key Insight:** Your organic certification commands a 25-40% premium '
            'that you\'re not fully capturing. Customers on Farm Fresh are willing to pay more for verified quality.',
        'bundle':
            'Product Bundle Strategies:\n\n'
            '**1. The Breakfast Box — \$18.99** (saves \$3.47)\n'
            '- Farm Fresh Eggs + Sourdough Bread + Raw Honey + Strawberries\n'
            '- Target: Weekday morning convenience\n\n'
            '**2. The Salad Kit — \$12.99** (saves \$2.47)\n'
            '- Baby Spinach + Organic Tomatoes + Goat Cheese + Fresh Basil\n'
            '- Target: Health-conscious lunch shoppers\n\n'
            '**3. The Grill Pack — \$24.99** (saves \$4.46)\n'
            '- Grass-Fed Beef + Sweet Corn (4) + Tomatoes + Basil\n'
            '- Target: Weekend BBQ families\n\n'
            '**4. The Weekly Essentials — \$34.99** (saves \$7.95)\n'
            '- Eggs + Spinach + Tomatoes + Bread + Honey + Seasonal Fruit\n'
            '- Target: Subscription-ready basket\n\n'
            'Bundles increase average order value by 35% and reduce decision fatigue.',
        'default':
            'I\'m Victor, your pricing strategist.\n\n'
            'I can help with:\n'
            '- Market price benchmarking\n'
            '- Dynamic pricing models\n'
            '- Bundle and promotion strategy\n'
            '- Seasonal price adjustments\n'
            '- Premium positioning for organic products\n\n'
            'What pricing question can I answer?',
      },
    ),

    // ── SUSTAINABILITY ADVISOR ──
    AgentPersona(
      id: 'sustainability',
      name: 'Sage',
      role: 'Sustainability Advisor',
      division: 'Specialized',
      emoji: '🌍',
      description:
          'Environmental impact specialist helping farms and marketplace operations reduce footprint and build sustainable practices.',
      vibe: 'Sustainability isn\'t a cost — it\'s your biggest competitive advantage.',
      specialties: [
        'Carbon footprint reduction',
        'Sustainable packaging',
        'Regenerative farming',
        'Green certifications',
        'Impact reporting',
      ],
      sampleQuestions: [
        'How can I reduce packaging waste?',
        'What is regenerative farming?',
        'Help me get a green certification',
        'Calculate my carbon footprint',
      ],
      color: Color(0xFF009688),
      icon: Icons.eco,
      responses: {
        'packaging':
            'Sustainable Packaging Roadmap:\n\n'
            '**Phase 1 — Quick Wins (This Month):**\n'
            '- Switch to compostable produce bags (\$0.03 more/bag)\n'
            '- Replace styrofoam with mushroom-based insulation\n'
            '- Use paper tape instead of plastic\n'
            '- Cost impact: +\$0.15/order\n\n'
            '**Phase 2 — Brand Builder (Next Quarter):**\n'
            '- Reusable delivery totes (\$2 deposit, returned on next order)\n'
            '- QR code on packaging → farm story + sustainability impact\n'
            '- "Zero Waste" badge on product listings\n'
            '- Customer survey: 73% will pay \$0.50 more for eco packaging\n\n'
            '**Phase 3 — Industry Leader (6 Months):**\n'
            '- Fully circular packaging (100% compostable/reusable)\n'
            '- Carbon-neutral delivery fleet (e-bikes for urban zones)\n'
            '- Annual sustainability report published in-app\n\n'
            'Marketing value: Sustainable brands see 28% higher customer loyalty.',
        'regenerative':
            'Regenerative Farming Guide:\n\n'
            '**What is it?**\n'
            'Goes beyond organic — actively improves soil health, biodiversity, and carbon sequestration.\n\n'
            '**Core Practices:**\n'
            '1. **Cover Cropping** — Plant off-season crops to prevent erosion\n'
            '2. **No-Till Farming** — Preserves soil structure and microbiome\n'
            '3. **Crop Rotation** — 4-year cycles prevent nutrient depletion\n'
            '4. **Composting** — Food waste → soil amendment → next crop\n'
            '5. **Integrated Pest Management** — Beneficial insects over chemicals\n\n'
            '**Business Impact:**\n'
            '- 20% reduction in input costs after year 2\n'
            '- "Regenerative" label commands 30% premium over conventional\n'
            '- Eligible for USDA conservation grants (\$5,000-50,000)\n'
            '- Carbon credit revenue: \$15-25/acre/year\n\n'
            'Would you like a transition plan for your farm?',
        'default':
            'Hi! I\'m Sage, your sustainability advisor.\n\n'
            'I can help with:\n'
            '- Eco-friendly packaging solutions\n'
            '- Regenerative farming practices\n'
            '- Carbon footprint calculation\n'
            '- Green certification guidance\n'
            '- Sustainability marketing\n\n'
            'How can we make your farm more sustainable?',
      },
    ),
  ];

  static AgentPersona getAgent(String id) {
    return agents.firstWhere((a) => a.id == id, orElse: () => agents.first);
  }

  static List<AgentPersona> getAgentsForRole(String role) {
    switch (role) {
      case 'farmer':
        return agents;
      case 'customer':
        return agents
            .where((a) =>
                a.id == 'support' ||
                a.id == 'nutrition' ||
                a.id == 'sustainability')
            .toList();
      case 'driver':
        return agents
            .where((a) => a.id == 'supply-chain' || a.id == 'support')
            .toList();
      default:
        return agents;
    }
  }
}
