module FirebaseTokenAuth
  class Validator
    ISSUER_BASE_URL = 'https://securetoken.google.com/'.freeze

    def validate(project_id, decoded_jwt)
      # ref. https://github.com/firebase/firebase-admin-node/blob/488f9318350c6b46af2e93b99907b9a02f170029/src/auth/token-verifier.ts
      payload = decoded_jwt[0]
      header = decoded_jwt[1]
      issuer = ISSUER_BASE_URL + project_id
      raise unless header['kid']
      raise unless header['alg'] == ALGORITHM
      raise unless payload['aud'] == project_id
      raise unless payload['iss'] == issuer
      raise unless payload['sub'].is_a?(String)
      raise if payload['sub'].empty?
      raise if payload['sub'].size > 128
    end

    def extract_kid(id_token)
      decoded = JWT.decode(id_token, nil, false, algorithm: ALGORITHM)
      [decoded[1]['kid'], decoded]
    end
  end
end

