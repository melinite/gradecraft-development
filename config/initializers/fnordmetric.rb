FNORD_METRIC = FnordMetric::API.new

FNORD_METRIC_EVENTS = {}.tap do |hash|
  hash[:pageview] = lambda do |path, user|
    FNORD_METRIC.event(_type: "_pageview", url: path, _session: user ? user.id.to_s : "0", _namespace: 'gradecraft')
  end

  hash[:login] = lambda do |user|
    FNORD_METRIC.event(_type: "login", last_login: user.cached_last_login_at, _session: user.id.to_s, _namespace: 'gradecraft')
    FNORD_METRIC.event(_type: "_set_name", name: user.public_name, _session: user.id.to_s, _namespace: 'gradecraft')
    FNORD_METRIC.event(_type: "_set_picture", url: GravatarImageTag::gravatar_url(user.email.downcase), _session: user.id.to_s, _namespace: 'gradecraft')
  end

  hash[:predictor_set] = lambda do |user, assignment_id, score, possible|
    FNORD_METRIC.event(
      _session: user.id.to_s,
      _type: :predictor_set,
      _namespace: 'gradecraft',
      assignment: assignment_id,
      score: score,
      possible: possible
    )
  end
end
