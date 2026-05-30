require "open-uri"

puts "=== Seeding Rakesh Shukla CRM ==="

# ---------------------------------------------------------------------------
# 1. Vidhansabha (Constituency)
# ---------------------------------------------------------------------------
vidhansabha = Vidhansabha.find_or_create_by!(name: "Mehgaon") do |r|
  r.district = "Bhind"
  r.state = "Madhya Pradesh"
end

# ---------------------------------------------------------------------------
# 2. Areas & Village/Wards
# ---------------------------------------------------------------------------
area_names = %w[Mehgaon Gormi Amayan Bhind Lahar]
area_names.each do |an|
  Area.find_or_create_by!(name: an, vidhansabha: vidhansabha)
end

village_data = {
  "Mehgaon" => %w[Ater Barou],
  "Gormi"   => %w[Ren Khatoli],
  "Amayan"  => %w[Jigna Barha],
  "Bhind"   => %w[Garotha Malanpur],
  "Lahar"   => %w[Umri Sihoni],
}

village_data.each do |area_name, villages|
  area = Area.find_by!(name: area_name)
  villages.each do |v|
    VillageWard.find_or_create_by!(name: v, area: area) { |vw| vw.kind = :rural }
  end
  # ensure urban ward exists
  VillageWard.find_or_create_by!(name: "#{area_name} Town", area: area) { |vw| vw.kind = :urban }
  VillageWard.find_or_create_by!(name: "#{area_name} Urban", area: area) { |vw| vw.kind = :urban }
end

puts "  ✓ Vidhansabha, Areas, and Village/Wards created"

# ---------------------------------------------------------------------------
# 3. Permissions (same as before)
# ---------------------------------------------------------------------------
permissions = {
  manage_population: "Manage population records",
  manage_campaigns:  "Manage campaign outreach",
  manage_requests:   "Manage requests and complaints",
  manage_users:      "Manage users and team members",
  manage_roles:      "Manage role permissions",
  manage_pr:         "Manage PR posts and media",
  manage_areas:      "Manage areas and villages",
  manage_work:       "Manage work tracking",
  view_analytics:    "View reports and analytics",
  submit_requests:   "Submit and track public requests",
}

permission_records = {}
permissions.each do |key, desc|
  permission_records[key] = Permission.find_or_create_by!(key: key.to_s) do |p|
    p.name = key.to_s.titleize
    p.description = desc
  end
end

# ---------------------------------------------------------------------------
# 4. Role-Permission mapping
# ---------------------------------------------------------------------------
role_permissions_map = {
  super_admin:          permissions.keys,
  admin:                %i[manage_population manage_campaigns manage_requests manage_users manage_pr manage_areas manage_work view_analytics],
  sub_admin:            %i[manage_population manage_requests manage_areas view_analytics],
  district_manager:     %i[view_analytics manage_requests],
  area_manager:         %i[manage_population manage_requests manage_areas manage_work],
  field_worker:         %i[manage_requests manage_work],
  volunteer:            %i[manage_campaigns],
  pr_team:              %i[manage_pr],
  data_entry_operator:  %i[manage_population],
  complaint_manager:    %i[manage_requests],
  campaign_manager:     %i[manage_campaigns view_analytics],
  public_user:          %i[submit_requests],
}

role_permissions_map.each do |role, keys|
  keys.each do |key|
    RolePermission.find_or_create_by!(role: role, permission: permission_records[key])
  end
end

puts "  ✓ Permissions and Role-permissions created"

# ---------------------------------------------------------------------------
# 5. Users (Admin team + public users)
# ---------------------------------------------------------------------------
admin = User.find_or_create_by!(mobile_number: "9999999999") do |u|
  u.name = "राकेश शुक्ला"
  u.role = :super_admin
  u.password = "admin123"
  u.address = "Mehgaon, Bhind, Madhya Pradesh"
  u.area = "Mehgaon"
  u.village_or_ward = "Mehgaon Town"
  u.preferred_language = "hi"
end

team_members = [
  { mobile: "9999999991", name: "दिनेश शुक्ला",          role: :admin,            area: "Mehgaon" },
  { mobile: "9999999992", name: "राहुल सिंह भदौरिया",     role: :complaint_manager, area: "Gormi" },
  { mobile: "9999999993", name: "संजीव श्रीवास्तव",       role: :data_entry_operator, area: "Amayan" },
  { mobile: "9999999994", name: "आलोक शुक्ला",            role: :campaign_manager,   area: "Mehgaon" },
  { mobile: "9999999995", name: "वीर सिंह चौहान",         role: :area_manager,       area: "Bhind" },
  { mobile: "9999999996", name: "प्रहलाद शर्मा",          role: :field_worker,       area: "Lahar" },
  { mobile: "9999999997", name: "अमित शर्मा",             role: :pr_team,            area: "Mehgaon" },
]

team_members.each do |tm|
  User.find_or_create_by!(mobile_number: tm[:mobile]) do |u|
    u.name = tm[:name]
    u.role = tm[:role]
    u.password = "team123"
    u.area = tm[:area]
    u.village_or_ward = "#{tm[:area]} Town"
    u.preferred_language = "hi"
  end
end

public_users = [
  { mobile: "8888888801", name: "राम प्रसाद गुप्ता",   area: "Mehgaon", village: "Mehgaon Town" },
  { mobile: "8888888802", name: "सीता देवी",          area: "Mehgaon", village: "Mehgaon Town" },
  { mobile: "8888888803", name: "मोहन लाल वर्मा",     area: "Gormi",   village: "Gormi Town" },
  { mobile: "8888888804", name: "कमला बाई",           area: "Amayan",  village: "Amayan Town" },
  { mobile: "8888888805", name: "राजेश कुमार",        area: "Bhind",   village: "Bhind Town" },
  { mobile: "8888888806", name: "सुनीता यादव",        area: "Lahar",   village: "Lahar Town" },
  { mobile: "8888888807", name: "गजेंद्र सिंह",        area: "Mehgaon", village: "Mehgaon Town" },
  { mobile: "8888888808", name: "अनिता शुक्ला",        area: "Mehgaon", village: "Mehgaon Town" },
  { mobile: "8888888809", name: "ओ. पी. एस. भदौरिया", area: "Gormi",  village: "Gormi Town" },
  { mobile: "8888888810", name: "मुकेश चतुर्वेदी",      area: "Bhind",  village: "Bhind Town" },
]

public_users.each do |pu|
  User.find_or_create_by!(mobile_number: pu[:mobile]) do |u|
    u.name = pu[:name]
    u.role = :public_user
    u.area = pu[:area]
    u.village_or_ward = pu[:village]
    u.preferred_language = "hi"
  end
end

puts "  ✓ #{User.count} Users created (admin + team + public)"

# ---------------------------------------------------------------------------
# 6. Population Records (constituents)
# ---------------------------------------------------------------------------
constituents = [
  { name: "राम प्रसाद गुप्ता",   phone: "9876543201", age: 45, gender: :male,   area: "Mehgaon", village: "Mehgaon Town", support: :supporter },
  { name: "मोहन लाल वर्मा",     phone: "9876543202", age: 52, gender: :male,   area: "Gormi",   village: "Gormi Town",   support: :neutral },
  { name: "सीता देवी",          phone: "9876543203", age: 38, gender: :female, area: "Mehgaon", village: "Ater",         support: :supporter },
  { name: "कमला बाई",          phone: "9876543204", age: 60, gender: :female, area: "Amayan",  village: "Amayan Town",  support: :supporter },
  { name: "राजेश कुमार",        phone: "9876543205", age: 33, gender: :male,   area: "Bhind",   village: "Bhind Town",   support: :opposition },
  { name: "सुनीता यादव",        phone: "9876543206", age: 29, gender: :female, area: "Lahar",   village: "Lahar Town",   support: :neutral },
  { name: "गजेंद्र सिंह",        phone: "9876543207", age: 55, gender: :male,   area: "Mehgaon", village: "Barou",        support: :supporter },
  { name: "अनिता शुक्ला",        phone: "9876543208", age: 48, gender: :female, area: "Mehgaon", village: "Mehgaon Town", support: :supporter },
  { name: "प्रदीप शर्मा",        phone: "9876543209", age: 41, gender: :male,   area: "Gormi",   village: "Ren",          support: :supporter },
  { name: "राधा बाई",           phone: "9876543210", age: 65, gender: :female, area: "Amayan",  village: "Jigna",        support: :neutral },
  { name: "सुरेश यादव",         phone: "9876543211", age: 37, gender: :male,   area: "Bhind",   village: "Garotha",      support: :opposition },
  { name: "पूनम यादव",          phone: "9876543212", age: 27, gender: :female, area: "Lahar",   village: "Umri",         support: :unknown_support },
  { name: "दीपक जैन",           phone: "9876543213", age: 50, gender: :male,   area: "Mehgaon", village: "Mehgaon Urban", support: :supporter },
  { name: "सावित्री देवी",       phone: "9876543214", age: 58, gender: :female, area: "Gormi",   village: "Khatoli",      support: :supporter },
  { name: "हरि ओम शर्मा",       phone: "9876543215", age: 42, gender: :male,   area: "Amayan",  village: "Barha",        support: :neutral },
]

population_records = constituents.map do |c|
  area = Area.find_by!(name: c[:area])
  vw = VillageWard.find_by!(area: area, name: c[:village])
  PopulationRecord.find_or_create_by!(phone_number: c[:phone]) do |r|
    r.full_name = c[:name]
    r.name = c[:name]
    r.age = c[:age]
    r.gender = c[:gender]
    r.area = c[:area]
    r.village_or_ward = c[:village]
    r.vidhansabha = vidhansabha
    r.area_ref = area
    r.village_ward = vw
    r.political_support_status = c[:support]
    r.rural_or_urban = :rural
  end
end

puts "  ✓ #{PopulationRecord.count} Population records created"

# ---------------------------------------------------------------------------
# 7. Campaigns
# ---------------------------------------------------------------------------
campaigns_data = [
  { title: "जन समस्या शिविर",            desc: "मेहगांव क्षेत्र में जन समस्याओं के समाधान हेतु शिविर",             area: "Mehgaon", village: "Mehgaon Town", status: :active,    image: "campaigns/campaign-public-meeting-1.svg" },
  { title: "संकल्प से समाधान अभियान",      desc: "ग्रामीण क्षेत्रों में विकास कार्यों की समीक्षा",                  area: "Gormi",   village: "Gormi Town",   status: :active,    image: "campaigns/campaign-resolution.svg" },
  { title: "नवकरणीय ऊर्जा जागरूकता रैली", desc: "सौर ऊर्जा के उपयोग हेतु जन जागरूकता अभियान",                      area: "Amayan",  village: "Amayan Town", status: :scheduled, image: "campaigns/campaign-solar-1.svg" },
  { title: "वृक्षारोपण अभियान",           desc: "पर्यावरण संरक्षण हेतु वृक्षारोपण कार्यक्रम",                         area: "Bhind",   village: "Bhind Town",  status: :scheduled, image: "campaigns/campaign-tree-plantation.svg" },
  { title: "महिला सशक्तिकरण शिविर",       desc: "महिलाओं हेतु स्वरोजगार प्रशिक्षण शिविर",                             area: "Lahar",   village: "Lahar Town",  status: :draft,     image: "campaigns/campaign-women-empowerment.svg" },
  { title: "किसान सम्मान सम्मेलन",         desc: "किसानों को सरकारी योजनाओं की जानकारी",                               area: "Mehgaon", village: "Ater",        status: :completed, image: "campaigns/campaign-kisan-samman.svg" },
  { title: "स्वच्छता अभियान",             desc: "गांव-गांव में स्वच्छता जागरूकता और सफाई अभियान",                     area: "Mehgaon", village: "Barou",       status: :completed, image: "campaigns/campaign-cleanliness.svg" },
]

campaigns_data.each do |c|
  Campaign.find_or_create_by!(title: c[:title]) do |camp|
    camp.description = c[:desc]
    camp.language = "hi"
    camp.target_area = c[:area]
    camp.target_village = c[:village]
    camp.campaign_status = c[:status]
    camp.scheduled_at = c[:status] == :scheduled ? 10.days.from_now : nil
    camp.image_url = "/images/politicians/rakesh_shukla/#{c[:image]}"
  end
end

puts "  ✓ #{Campaign.count} Campaigns created"

# ---------------------------------------------------------------------------
# 8. PR/News Posts
# ---------------------------------------------------------------------------
pr_image_base = "/images/politicians/rakesh_shukla/news"
pr_posts_data = [
  { title: "मुख्यमंत्री मोहन यादव ने मेहगांव को दिए विकास की सौगातें", content: "मुख्यमंत्री डॉ. मोहन यादव ने मेहगांव विधानसभा क्षेत्र को 50 करोड़ रुपये की विकास परियोजनाओं की सौगात दी। इस दौरान कैबिनेट मंत्री श्री राकेश शुक्ला भी उपस्थित रहे।", status: :published, days_ago: 2,  image: "news-energy-initiative.svg" },
  { title: "नवकरणीय ऊर्जा मंत्री राकेश शुक्ला ने सौर संयंत्र का किया निरीक्षण", content: "नवीन एवं नवकरणीय ऊर्जा मंत्री श्री राकेश शुक्ला ने मोरेना सौर संयंत्र का निरीक्षण किया। इस संयंत्र से चंबल क्षेत्र की तस्वीर बदलने का दावा किया गया है।", status: :published, days_ago: 5,  image: "news-renewable-energy.svg" },
  { title: "ग्रामीणों ने सरकारी योजनाओं का उठाया लाभ", content: "प्रधानमंत्री कॉलेज ऑफ एक्सीलेंस का शुभारंभ कार्यक्रम भिंड जिले में मंत्री श्री राकेश शुक्ला की मौजूदगी में संपन्न हुआ।", status: :published, days_ago: 10, image: "news-rural-development.svg" },
  { title: "मेहगांव में स्वच्छता अभियान की तैयारी", content: "आगामी स्वच्छता अभियान के तहत मेहगांव के सभी वार्डों में सफाई व्यवस्था चुस्त-दुरुस्त करने के निर्देश दिए गए हैं।", status: :published, days_ago: 15, image: "news-cleanliness-drive.svg" },
  { title: "किसानों के लिए नई सिंचाई योजना", content: "प्रदेश सरकार ने किसानों के लिए नई सिंचाई योजना का प्रस्ताव तैयार किया है। जल कर में छूट देने का भी निर्णय लिया गया।", status: :draft,      image: "news-rural-development.svg" },
  { title: "युवाओं के लिए रोजगार मेला", content: "मेहगांव क्षेत्र के युवाओं के लिए रोजगार मेले का आयोजन अगले माह किया जाएगा।", status: :scheduled, image: "news-youth-employment.svg" },
]

pr_posts_data.each do |pp|
  PrPost.find_or_create_by!(title: pp[:title]) do |post|
    post.content = pp[:content]
    post.language = "hi"
    post.status = pp[:status]
    post.user = admin
    post.published_at = pp[:days_ago] ? pp[:days_ago].days.ago : nil
    post.scheduled_at = pp[:status] == :scheduled ? 7.days.from_now : nil
    post.image_url = "#{pr_image_base}/#{pp[:image]}"
  end
end

puts "  ✓ #{PrPost.count} PR/News posts created"

# ---------------------------------------------------------------------------
# 9. Work Done
# ---------------------------------------------------------------------------
work_done_data = [
  { title: "मेहगांव ग्राम पंचायत भवन निर्माण",          type: "भवन निर्माण",     area: "Mehgaon", village: "Mehgaon Town", budget: 25_00_000 },
  { title: "गोरमी में सड़क निर्माण कार्य",              type: "सड़क निर्माण",    area: "Gormi",   village: "Gormi Town",   budget: 40_00_000 },
  { title: "अमायन में तालाब जीर्णोद्धार",              type: "जल संरक्षण",     area: "Amayan",  village: "Amayan Town",  budget: 15_00_000 },
  { title: "भिंड में सौर लाइट लगाना",                  type: "ऊर्जा",          area: "Bhind",   village: "Bhind Town",   budget: 8_00_000 },
  { title: "लहर में स्कूल भवन मरम्मत",                 type: "शिक्षा",          area: "Lahar",   village: "Lahar Town",   budget: 12_00_000 },
  { title: "मेहगांव में पानी की टंकी निर्माण",          type: "जल आपूर्ति",     area: "Mehgaon", village: "Mehgaon Town", budget: 20_00_000 },
  { title: "बरौ में सामुदायिक केंद्र निर्माण",          type: "भवन निर्माण",     area: "Mehgaon", village: "Mehgaon Town", budget: 18_00_000 },
]

work_done_data.each_with_index do |wd, i|
  pop_record = population_records[i % population_records.size]
  WorkDone.find_or_create_by!(title: wd[:title]) do |work|
    work.work_type = wd[:type]
    work.description = "#{wd[:title]} का कार्य पूर्ण हो चुका है।"
    work.area = wd[:area]
    work.village = wd[:village]
    work.budget = wd[:budget]
    work.status = :completed
    work.completed_at = rand(1..60).days.ago
    work.population_record = pop_record
  end
end

puts "  ✓ #{WorkDone.count} Work done records created"

# ---------------------------------------------------------------------------
# 10. Public Requests (complaints/grievances)
# ---------------------------------------------------------------------------
requests_data = [
  { title: "पानी की समस्या",           category: :water,             desc: "वार्ड में पीने के पानी की आपूर्ति ठप है। कृपया शीघ्र समाधान करें।",                     area: "Mehgaon", village: "Mehgaon Town", status: :resolved },
  { title: "सड़क टूटी हुई है",         category: :road,              desc: "मेहगांव-गोरमी मार्ग पर सड़क जर्जर हो गई है। दुर्घटना का खतरा बना रहता है।",              area: "Mehgaon", village: "Mehgaon Town", status: :in_progress },
  { title: "बिजली की समस्या",          category: :electricity,       desc: "गांव में तीन दिन से बिजली नहीं है। ट्रांसफार्मर खराब हो गया है।",                        area: "Gormi",   village: "Gormi Town",   status: :assigned },
  { title: "अस्पताल में डॉक्टर नहीं",  category: :hospital,          desc: "सामुदायिक स्वास्थ्य केंद्र पर डॉक्टर नियमित रूप से उपलब्ध नहीं होते।",                    area: "Amayan",  village: "Amayan Town",  status: :new_request },
  { title: "पेंशन नहीं मिल रही",       category: :pension,           desc: "वृद्धावस्था पेंशन पिछले तीन माह से नहीं मिली है।",                                        area: "Bhind",   village: "Bhind Town",   status: :resolved },
  { title: "गंदगी का ढेर",             category: :sanitation,        desc: "गली में काफी दिनों से कूड़ा पड़ा है। कोई सफाई नहीं हो रही।",                               area: "Lahar",   village: "Lahar Town",   status: :resolved },
  { title: "सरकारी योजना का लाभ नहीं", category: :government_scheme, desc: "प्रधानमंत्री आवास योजना का लाभ अभी तक नहीं मिला।",                                       area: "Mehgaon", village: "Mehgaon Town", status: :in_progress },
  { title: "शिक्षा में सुधार",          category: :education,         desc: "स्कूल में शिक्षकों की कमी है। पढ़ाई ठीक से नहीं हो पा रही।",                                 area: "Gormi",   village: "Gormi Town",   status: :new_request },
  { title: "भ्रष्टाचार की शिकायत",      category: :corruption,        desc: "राशन वितरण में अनियमितता की शिकायत।",                                                       area: "Amayan",  village: "Amayan Town",  status: :escalated },
  { title: "आपातकालीन मदद",            category: :emergency,         desc: "बाढ़ प्रभावित क्षेत्र में तत्काल मदद की आवश्यकता।",                                         area: "Mehgaon", village: "Mehgaon Town", status: :resolved },
]

requests_data.each do |r|
  pu = User.public_user.find_by(area: r[:area]) || User.public_user.first
  PublicRequest.find_or_create_by!(request_title: r[:title], phone_number: pu.mobile_number) do |req|
    req.public_user = pu
    req.name = pu.name
    req.phone_number = pu.mobile_number
    req.area = r[:area]
    req.village_or_ward = r[:village]
    req.category = r[:category]
    req.description = r[:desc]
    req.status = r[:status]
  end
end

puts "  ✓ #{PublicRequest.count} Public requests created"

# ---------------------------------------------------------------------------
# 11. MLA Profile
# ---------------------------------------------------------------------------
Profile.find_or_create_by!(name: "राकेश शुक्ला") do |p|
  p.title = "कैबिनेट मंत्री / विधायक"
  p.party = "भारतीय जनता पार्टी"
  p.constituency = "मेहगांव, भिंड, मध्य प्रदेश"
  p.department = "नवीन एवं नवकरणीय ऊर्जा मंत्री, मध्य प्रदेश सरकार"
  p.image_url = "/images/politicians/rakesh_shukla/profile/profile-main.svg"
  p.biography = <<~BIO
    राकेश शुक्ला भारतीय जनता पार्टी के वरिष्ठ नेता हैं। वर्तमान में मध्य प्रदेश सरकार में कैबिनेट मंत्री तथा मेहगांव विधानसभा क्षेत्र से विधायक हैं।
    25 दिसंबर 2023 को मुख्यमंत्री डॉ. मोहन यादव के मंत्रिमंडल में कैबिनेट मंत्री के रूप में शपथ ली। उन्हें नवीन एवं नवकरणीय ऊर्जा विभाग का मंत्री बनाया गया।
    राकेश शुक्ला किसान और ग्रामीण पृष्ठभूमि से आते हैं। उनके पिता स्वर्गीय शिव कुमार शुक्ला हाईकोर्ट अधिवक्ता और भाजपा के जिलाध्यक्ष रहे हैं।
    बचपन से ही राष्ट्रीय स्वयंसेवक संघ से जुड़े राकेश शुक्ला की राजनीति में सक्रिय भूमिका रही है। वे तीसरी बार विधायक चुने गए हैं।
  BIO
  p.political_experience = <<~EXP
    1998-2003: पहली बार मेहगांव विधानसभा से विधायक निर्वाचित
    2008-2013: दूसरी बार मेहगांव विधानसभा से विधायक निर्वाचित
    2023-वर्तमान: तीसरी बार विधायक निर्वाचित
    25 दिसंबर 2023: मध्य प्रदेश सरकार में कैबिनेट मंत्री के रूप में शपथ
    विभाग: नवीन एवं नवकरणीय ऊर्जा मंत्री
  EXP
  p.focus_areas = <<~FOCUS
    नवकरणीय ऊर्जा को बढ़ावा देना
    ग्रामीण विकास एवं बुनियादी ढांचा
    सड़क, बिजली, पानी जैसी मूलभूत समस्याओं का समाधान
    शिक्षा एवं स्वास्थ्य सुविधाओं में सुधार
    किसान कल्याण एवं सिंचाई योजनाएं
    युवाओं के लिए रोजगार के अवसर
  FOCUS
  p.contact_info = <<~CONTACT
    {"कार्यालय": "मंत्रालय, भोपाल, मध्य प्रदेश", "विधानसभा क्षेत्र": "मेहगांव, भिंड, मध्य प्रदेश", "फोन": "जनसंपर्क कार्यालय, भिंड"}
  CONTACT
end

puts "  ✓ MLA Profile created"
puts ""
puts "=== Seeding Complete! ==="
puts "Admin login:  9999999999 / admin123"
puts "Team login:   9999999991 / team123"
puts "Public login: 8888888801 / (OTP based)"