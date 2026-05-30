module Api
  module Public
    class ProfileController < ApplicationController
      def show
        profile = Profile.first
        if profile
          render json: profile.as_json(methods: [:photo_url]).merge(
            image_url: profile.photo_url,
            political_experience: parse_list(profile.political_experience),
            focus_areas: parse_list(profile.focus_areas),
            contact_info: parse_hash(profile.contact_info)
          )
        else
          render json: {
            name: "राकेश शुक्ला",
            title: "Cabinet Minister / MLA",
            party: "भारतीय जनता पार्टी",
            constituency: "Mehgaon, Bhind, Madhya Pradesh",
            department: "नवीन एवं नवकरणीय ऊर्जा मंत्री",
            image_url: "/images/politicians/rakesh_shukla/profile/profile-main.svg",
            biography: "राकेश शुक्ला भारतीय जनता पार्टी के वरिष्ठ नेता हैं। वर्तमान में मध्य प्रदेश सरकार में कैबिनेट मंत्री तथा मेहगांव विधानसभा क्षेत्र से विधायक हैं।",
            political_experience: ["1998-2003: पहली बार विधायक निर्वाचित", "2008-2013: दूसरी बार विधायक निर्वाचित", "2023-वर्तमान: तीसरी बार विधायक निर्वाचित एवं कैबिनेट मंत्री"],
            focus_areas: ["नवकरणीय ऊर्जा को बढ़ावा", "ग्रामीण विकास", "सड़क एवं बुनियादी ढांचा", "शिक्षा एवं स्वास्थ्य", "किसान कल्याण"],
            contact_info: { "कार्यालय" => "मंत्रालय, भोपाल, मध्य प्रदेश", "विधानसभा" => "मेहगांव, भिंड, मध्य प्रदेश" }
          }
        end
      end

      private

      def parse_list(value)
        return [] if value.blank?
        value.is_a?(String) ? value.split("\n").map(&:strip).reject(&:blank?) : value
      end

      def parse_hash(value)
        return {} if value.blank?
        return value unless value.is_a?(String)
        JSON.parse(value) rescue {}
      end
    end
  end
end