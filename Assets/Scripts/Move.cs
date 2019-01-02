using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour {

    [SerializeField, Range(0f, 100f)]
    float _repeatAbs = 10f;

    [SerializeField, Range(-100f, 100f)]
    float _speed = 1f;

    Vector3 _p;

    void Start () {
        _p = transform.localPosition;
    }
	
	void Update () {

        var y = _p.y;
        y += Time.time * _speed + _repeatAbs;
        y = Mathf.Repeat(Mathf.Abs(y), _repeatAbs * 2) - _repeatAbs;
        transform.localPosition = new Vector3(_p.x, y, _p.z);

	}
}
